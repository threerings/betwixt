//
// nod - Copyright 2012 Three Rings Design

#import "BTMovieButton.h"
#import "BTButton+Protected.h"
#import "BTMovie.h"

@implementation BTMovieButton

- (id)initWithMovie:(BTMovie*)movie {
    if ((self = [super init])) {
        _movie = movie;
        [_sprite addChild:_movie];
        [_movie gotoFrame:BT_ButtonUp];
        _clickBounds = [_movie bounds];
    }
    return self;
}

- (void)displayState:(BTButtonState)state {
    [_movie gotoFrame:state];
}

- (SPRectangle*)clickBounds {
    return _clickBounds;
}

@end
