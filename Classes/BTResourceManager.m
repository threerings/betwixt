//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTResourceManager.h"
#import "BTResourceFactory.h"
#import "BTResource.h"
#import "GDataXMLException.h"

#import "GDataXMLNode+OOO.h"

@interface BTResourceManager ()
- (id<BTResourceFactory>)getFactory:(NSString *)type;
@end

@implementation BTResourceManager

+ (BTResourceManager *)sharedManager {
    static BTResourceManager *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[BTResourceManager alloc] init];
        }
    }
    return instance;
}

- (id)init {
    if (!(self = [super init])) {
        return nil;
    }
    _factories = [[NSMutableDictionary alloc] init];
    _resources = [[NSMutableDictionary alloc] init];
    return self;
}

- (void)loadResourceFile:(NSString *)filename {
    NSString *strippedFilename = [filename stringByDeletingPathExtension];
    NSString *extension = [filename pathExtension];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSData *data = [NSData dataWithContentsOfFile:
                    [bundle pathForResource:strippedFilename ofType:extension]];
    if (data == nil) {
        @throw [GDataXMLException withReason:@"Unable to load file '%@'", filename];
    }
    
    NSError *err;
    GDataXMLDocument *xmldoc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&err];
    if (xmldoc == nil) {
        @throw [[NSException alloc] initWithName:NSGenericException 
                                          reason:[err localizedDescription] 
                                        userInfo:[err userInfo]];
    }
    
    // Create the resources
    GDataXMLElement *root = [xmldoc rootElement];
    for (GDataXMLElement *child in [root elements]) {
        NSString *type = [child name];
        // find the resource factory for this type
        id<BTResourceFactory> factory = [self getFactory:type];
        NSAssert(factory != nil, @"No ResourceFactory for '%@'", type);
        // create the resource
        NSString* name = [child stringAttribute:@"name"];
        NSAssert(![self isLoaded:name], @"A resource with that name already exists: '%@'", name);
        id<BTResource> rsrc = [factory create:name group:filename xml:child];
        // add it to the batch
        [_resources setValue:rsrc forKey:name];
    }
}

- (id<BTResource>)getResource:(NSString *)name {
    return [_resources objectForKey:name];
}

- (id<BTResource>)requireResource:(NSString *)name {
    id<BTResource> rsrc = [self getResource:name];
    NSAssert(rsrc != nil, @"No such resource: %@", name);
    return rsrc;
}

- (BOOL)isLoaded:(NSString *)name {
    return [self getResource:name] != nil;
}

- (void)unloadGroup:(NSString *)group {
    for (id<BTResource>rsrc in [_resources allValues]) {
        if ([rsrc.group isEqualToString:group]) {
            [_resources removeObjectForKey:rsrc.name];
        }
    }
}

- (void)unloadAll {
    [_resources removeAllObjects];
}

- (void)registerFactory:(id<BTResourceFactory>)factory forType:(NSString *)type {
    [_factories setObject:factory forKey:type];
}

- (id<BTResourceFactory>)getFactory:(NSString *)type {
    return [_factories objectForKey:type];
}

@end
