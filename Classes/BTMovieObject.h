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

+ (void)makeOneShot:(BTMovieObject*)movieObj;

+ (BTMovieObject*)movieObjectWithMovieName:(NSString*)movieName;
+ (BTMovieObject*)movieObjectWithMovieResource:(BTMovieResource*)resource;

/// Create a BTMovieObject that will play once and then remove itself
+ (BTMovieObject*)oneShotMovieObjectWithMovieName:(NSString*)movieName;
+ (BTMovieObject*)oneShotMovieObjectWithMovieResource:(BTMovieResource*)resource;

- (id)initWithMovieName:(NSString*)movieName;
- (id)initWithMovieResource:(BTMovieResource*)resource;

@end
