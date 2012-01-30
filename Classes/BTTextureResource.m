//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTTextureResource.h"
#import "BTResourceFactory.h"
#import "GDataXMLNode+OOO.h"

@interface BTTextureFactory : NSObject<BTResourceFactory>
@end

@implementation BTTextureResource

+ (id<BTResourceFactory>)sharedFactory {
    static BTTextureFactory *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[BTTextureFactory alloc] init];
        }
    }
    return instance;
}

@synthesize texture = _texture, offset = _offset;

- (id)initWithXml:(GDataXMLElement *)xml {
    if (!(self = [super init])) return nil;
    _texture = [[SPTexture alloc] initWithContentsOfFile:[xml stringAttribute:@"filename"]];
    _offset = [[SPPoint alloc] initWithX:[xml intAttribute:@"xOffset" defaultVal:0]
                                       y:[xml intAttribute:@"yOffset" defaultVal:0]];
    return self;
}

@end

@implementation BTTextureFactory

- (BTResource *)create:(GDataXMLElement *)xml {
    return [[BTTextureResource alloc] initWithXml:xml];
}

@end
