//
//  Betwixt - Copyright 2012 Three Rings Design

#import "BTResource.h"

#define BTTEXTURE_RESOURCE_NAME @"texture"

@protocol BTResourceFactory;

@interface BTTexture : SPTexture <BTResource> {
@private
    NSString *_name;
    NSString *_group;
}

+ (id<BTResourceFactory>) sharedFactory;

@property(nonatomic,readonly) NSString *name;
@property(nonatomic,readonly) NSString *group;

@end
