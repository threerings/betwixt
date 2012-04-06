//
// nod - Copyright 2012 Three Rings Design

#import "BTMovieButton.h"
#import "BTButton+Protected.h"
#import "BTMovie.h"

static NSString* const STATE_LABELS [] = { @"up", @"down", @"disabled" };

@implementation BTMovieButton

- (id)initWithMovie:(BTMovie*)movie {
    if (!(self = [super init])) {
        return nil;
    }
    _movie = movie;
    [_sprite addChild:_movie];
    [_movie gotoLabel:STATE_LABELS[BT_BUTTON_STATE_UP]];
    _clickBounds = [_movie bounds];
    return self;
}

- (void)displayState:(BTButtonState)state {
    [_movie gotoLabel:STATE_LABELS[state]];
}

- (SPRectangle*)clickBounds {
    return _clickBounds;
}

@end
