//
//  Betwixt - Copyright 2012 Three Rings Design

#import "BTResource.h"

@protocol BTResourceFactory;

@interface BTTextureResource : SPTexture <BTResource> {
@private
    NSString *_name;
    NSString *_group;
}

+ (id<BTResourceFactory>) sharedFactory;

@property(nonatomic,readonly) NSString *name;
@property(nonatomic,readonly) NSString *group;

@end
