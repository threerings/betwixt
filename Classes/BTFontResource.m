//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTFontResource.h"
#import "BTResource+Protected.h"
#import "BTResourceFactory.h"
#import "GDataXMLNode+BTExtensions.h"
#import "BTApp.h"
#import "BTResourceManager.h"

@interface BTFontFactory : NSObject<BTResourceFactory>
@end

@implementation BTFontResource

+ (id<BTResourceFactory>)sharedFactory {
    return OOO_SINGLETON([[BTFontFactory alloc] init]);
}

+ (BTFontResource*)require:(NSString*)name {
    return [BTApp.resourceManager requireResource:name ofType:[BTFontResource class]];
}

- (id)initWithXml:(GDataXMLElement*)xml {
    if ((self = [super init])) {
        NSString* filename = [BTApp requireResourcePathFor:[xml stringAttribute:@"filename"]];
        [SPTextField registerBitmapFontFromFile:filename name:[xml stringAttribute:@"name"]];
    }
    return self;
}

- (void)unload {
    [SPTextField unregisterBitmapFont:_name];
}

@end

@implementation BTFontFactory

- (BTResource*)create:(GDataXMLElement*)xml {
    return [[BTFontResource alloc] initWithXml:xml];
}

@end
