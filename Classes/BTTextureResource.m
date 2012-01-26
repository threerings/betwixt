//
//  Betwixt - Copyright 2012 Three Rings Design

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

@synthesize texture = _texture;

- (id)initWithFilename:(NSString *)filename {
    if (!(self = [super init])) {
        return nil;
    }
    _texture = [[SPTexture alloc] initWithContentsOfFile:filename];
    return self;
}

@end

@implementation BTTextureFactory

- (BTResource *)create:(GDataXMLElement *)xml {
    return [[BTTextureResource alloc] initWithFilename:[xml stringAttribute:@"filename"]];
}

@end
