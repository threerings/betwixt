//
// nod - Copyright 2012 Three Rings Design

#import "BTButton.h"

@class BTMovie;

/// A button that uses a three-frame BTMovie as its display
/// Frame 0: BT_ButtonUp
/// Frame 1: BT_ButtonDown
/// Frame 2: BT_ButtonDisabled

@interface BTMovieButton : BTButton {
    BTMovie* _movie;
    SPRectangle* _clickBounds;
}

- (id)initWithMovie:(BTMovie*)movie;

@end
