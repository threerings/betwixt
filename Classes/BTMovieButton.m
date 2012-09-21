//
// nod - Copyright 2012 Three Rings Design

#import "BTMovieButton.h"
#import "BTButton+Protected.h"
#import "BTMovie.h"

@implementation BTMovieButton

- (id)initWithMovie:(BTMovie*)movie upLabel:(NSString*)upLabel downLabel:(NSString*)downLabel
      disabledLabel:(NSString*)disabledLabel {
    if ((self = [super init])) {
        _movie = movie;
        _upLabel = upLabel;
        _downLabel = downLabel;
        _disabledLabel = disabledLabel;
        [_sprite addChild:_movie];
        [_movie gotoLabel:_upLabel];
        _clickBounds = [_movie bounds];
    }
    return self;
}

- (id)initWithMovie:(BTMovie*)movie {
    return [self initWithMovie:movie upLabel:@"up" downLabel:@"down" disabledLabel:@"disabled"];
}

- (void)displayState:(BTButtonState)state {
    NSString* label = nil;
    switch (state) {
    case BT_ButtonUp:        label = _upLabel; break;
    case BT_ButtonDown:      label = _downLabel; break;
    case BT_ButtonDisabled:  label = _disabledLabel; break;
    }

    [_movie gotoLabel:label];
}

- (SPRectangle*)clickBounds {
    return _clickBounds;
}

@end
