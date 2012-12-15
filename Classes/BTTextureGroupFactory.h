//
//  Betwixt - Copyright 2012 Three Rings Design

#import "BTResource.h"
#import "BTMultiResourceFactory.h"

#define BT_TEXTURE_GROUP_RESOURCE_NAME @"textureGroups"

@interface BTTextureGroupFactory : NSObject<BTMultiResourceFactory>

+ (id<BTMultiResourceFactory>) sharedFactory;

@end
