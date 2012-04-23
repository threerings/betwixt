//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPSprite.h"

#import "BTResource.h"
#import "BTDisplayObjectCreator.h"

#define BT_MOVIE_RESOURCE_NAME @"movie"

@protocol BTResourceFactory;
@class BTMovie;

@interface BTMovieResource : BTResource<BTDisplayObjectCreator>

+ (id<BTResourceFactory>)sharedFactory;
+ (BTMovieResource*)require:(NSString*)name;
+ (BTMovie*)newMovie:(NSString*)name;

- (BTMovie*)newMovie;

@end
