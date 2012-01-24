//
//  Betwixt - Copyright 2012 Three Rings Design

#import "BTTexture.h"
#import "BTResourceFactory.h"
#import "GDataXMLNode+OOO.h"

@interface BTTextureFactory : NSObject<BTResourceFactory>
@end

@implementation BTTexture

+ (id<BTResourceFactory>)sharedFactory {
    static BTTextureFactory *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[BTTextureFactory alloc] init];
        }
    }
    return instance;
}

@synthesize name = _name;
@synthesize group = _group;

- (id)initWithName:(NSString *)name group:(NSString *)group filename:(NSString *)filename {
    if (!(self = [super initWithContentsOfFile:filename])) {
        return nil;
    }
    _name = name;
    _group = group;
    return self;
}

@end

@implementation BTTextureFactory

- (id<BTResource>)create:(NSString *)name group:(NSString *)group xml:(GDataXMLElement *)xml {
    return [[BTTexture alloc] initWithName:name group:group filename:[xml stringAttribute:@"filename"]];
}

@end
