//
//  Betwixt - Copyright 2012 Three Rings Design

#import "BTResource.h"

#define BTTEXTURE_RESOURCE_NAME @"texture"

@protocol BTResourceFactory;

@interface BTTextureResource : BTResource {
@private
    SPTexture *_texture;
}

+ (id<BTResourceFactory>) sharedFactory;

@property(nonatomic,readonly) SPTexture *texture;

@end
