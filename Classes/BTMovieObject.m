//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMovieObject.h"
#import "BTMovieResource.h"
#import "BTMovie.h"

@implementation BTMovieObject

@synthesize movie = _movie;

+ (void)makeOneShot:(BTMovieObject*)movieObj {
    BTMovie* movie = movieObj.movie;
    [movie playToLabel:BTMovieLastFrame];
    [movieObj.conns addConnection:[movie monitorLabel:BTMovieLastFrame withUnit:^{
        [movieObj removeSelf];
    }]];
}

+ (BTMovieObject*)movieObjectWithMovieName:(NSString*)movieName {
    return [[BTMovieObject alloc] initWithMovieName:movieName];
}

+ (BTMovieObject*)movieObjectWithMovieResource:(BTMovieResource*)resource {
    return [[BTMovieObject alloc] initWithMovieResource:resource];
}

+ (BTMovieObject*)oneShotMovieObjectWithMovieName:(NSString*)movieName {
    BTMovieObject* obj = [[BTMovieObject alloc] initWithMovieName:movieName];
    [BTMovieObject makeOneShot:obj];
    return obj;
}

+ (BTMovieObject*)oneShotMovieObjectWithMovieResource:(BTMovieResource*)resource {
    BTMovieObject* obj = [[BTMovieObject alloc] initWithMovieResource:resource];
    [BTMovieObject makeOneShot:obj];
    return obj;
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
