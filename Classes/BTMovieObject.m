//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMovieObject.h"
#import "BTMovieResource.h"
#import "BTMovie.h"

@implementation BTMovieObject

@synthesize movie = _movie;

+ (BTMovieObject*)movieObjectWithMovieName:(NSString*)movieName {
    return [[BTMovieObject alloc] initWithMovieName:movieName];
}

+ (BTMovieObject*)movieObjectWithMovieResource:(BTMovieResource*)resource {
    return [[BTMovieObject alloc] initWithMovieResource:resource];
}

- (id)initWithMovieName:(NSString*)movieName {
    return [self initWithMovieResource:[BTMovieResource require:movieName]];
}

- (id)initWithMovieResource:(BTMovieResource*)resource {
    if ((self = [super initWithSprite:[resource newMovie]])) {
        _movie = (BTMovie*)_sprite;
    }
    return self;
}

@end
