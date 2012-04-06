//
// nod - Copyright 2012 Three Rings Design

#import "BTButton.h"

typedef enum {
    BT_BUTTON_STATE_UP = 0,
    BT_BUTTON_STATE_DOWN,
    BT_BUTTON_STATE_DISABLED
} BTButtonState;

@interface BTButton (protected)

/// Subclasses must implement these methods
- (SPRectangle*)clickBounds;
- (void)displayState:(BTButtonState)state;

@end