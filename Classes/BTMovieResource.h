//
//  Betwixt - Copyright 2012 Three Rings Design

#import "SPSprite.h"

#import "BTResource.h"

#define BTMOVIE_RESOURCE_NAME @"movie"

@protocol BTResourceFactory;

@interface BTMovieResource : BTResource

+ (id<BTResourceFactory>) sharedFactory;

@end
