//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTResourceGroup.h"
#import "BTResourceManager.h"
#import "BTLoadableBatch.h"
#import "BTResourceFactory.h"
#import "BTResource.h"
#import "GDataXMLException.h"

#import "GDataXMLNode+OOO.h"

@implementation BTResourceGroup

@synthesize name=_name;

- (id)initWithFilename:(NSString *)filename {
    if (!(self = [super init])) {
        return nil;
    }
    _filename = filename;
    _name = filename;
    return self;
}

- (id)initWithName:(NSString *)name xml:(NSString *)xmlString {
    if (!(self = [super init])) {
        return nil;
    }
    _name = name;
    _xmlString = xmlString;
    return self;
}

- (NSData *)getData {
    if (_filename != nil) {
        NSString *filename = [_filename stringByDeletingPathExtension];
        NSString *extension = [_filename pathExtension];
        
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSData *data = [NSData dataWithContentsOfFile:
                        [bundle pathForResource:filename ofType:extension]];
        if (data == nil) {
            @throw [GDataXMLException withReason:@"Unable to load file '%@'", _filename];
        }
        return data;
    } else {
        return [_xmlString dataUsingEncoding:NSUTF8StringEncoding];
    }
}

- (void)doLoad {
    NSData *data = [self getData];
    NSError *err;
    GDataXMLDocument *xmldoc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&err];
    if (xmldoc == nil) {
        [self loadError:[[NSException alloc] initWithName:NSGenericException 
                                                   reason:[err localizedDescription] 
                                                 userInfo:[err userInfo]]];
    }
    
    // Create the resources
    NSMutableArray *resources = [NSMutableArray array];
    @try {
        GDataXMLElement *root = [xmldoc rootElement];
        for (GDataXMLElement *child in [root elements]) {
            NSString *type = [child name];
            // find the resource factory for this type
            id<BTResourceFactory> factory = [[BTResourceManager sharedManager] getFactory:type];
            NSAssert(factory != nil, @"No ResourceFactory for '%@'", type);
            // create the resource
            NSString* name = [child stringAttribute:@"name"];
            BTResource *rsrc = [factory create:name group:_name xml:child];
            // add it to the batch
            [resources addObject:rsrc];
        }
    } @catch (NSException *err) {
        [self loadError:err];
        return;
    }
    
    // Load the resources
    BTLoadableBatch *batch = [[BTLoadableBatch alloc] init];
    for (BTResource *rsrc in resources) {
        [batch add:rsrc];
    }
    
    __weak BTResourceGroup *this = self;
    [batch load:^{
        @try {
            // Add all the resources to the resource manager
            for (BTResource *rsrc in resources) {
                [[BTResourceManager sharedManager] add:rsrc];
                
            }
        } @catch (NSException *err) {
            [this loadError:err];
        }
        [this loadSuccess]; 
    }
    onError:^(NSException *err) { 
        [this loadError:err]; 
    }];
}

@end
