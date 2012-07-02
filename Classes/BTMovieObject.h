//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTSpriteObject.h"

@class BTMovieResource;
@class BTMovie;

@interface BTMovieObject : BTSpriteObject {
@protected
    BTMovie* _movie;
}

@property (nonatomic,readonly) BTMovie* movie;

+ (BTMovieObject*)movieObjectWithMovieName:(NSString*)movieName;
+ (BTMovieObject*)movieObjectWithMovieResource:(BTMovieResource*)resource;

- (id)initWithMovieName:(NSString*)movieName;
- (id)initWithMovieResource:(BTMovieResource*)resource;

@end
