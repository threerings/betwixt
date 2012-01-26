//
//  Betwixt - Copyright 2012 Three Rings Design

#import "SPSprite.h"

#import "BTResource.h"

#define BTMOVIE_RESOURCE_NAME @"movie"

@protocol BTResourceFactory;

@interface BTMovieResource : NSObject<BTResource> {
@private
    NSString *_name;
    NSString *_group;
}

+ (id<BTResourceFactory>) sharedFactory;

@end
