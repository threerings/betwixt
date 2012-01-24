//
//  Betwixt - Copyright 2012 Three Rings Design

#import "BTTextureResource.h"
#import "BTResourceFactory.h"
#import "GDataXMLNode+OOO.h"

@interface BTTextureResourceFactory : NSObject<BTResourceFactory>
@end

@implementation BTTextureResource

+ (id<BTResourceFactory>)sharedFactory {
    static BTTextureResourceFactory *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[BTTextureResourceFactory alloc] init];
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

@implementation BTTextureResourceFactory

- (id<BTResource>)create:(NSString *)name group:(NSString *)group xml:(GDataXMLElement *)xml {
    return [[BTTextureResource alloc] initWithName:name group:group filename:[xml stringAttribute:@"filename"]];
}

@end
