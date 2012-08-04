//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTButton.h"

@interface BTButton (protected)

/// Abstract: subclasses must implement
- (SPRectangle*)clickBounds;
/// Abstract: subclasses must implement
- (void)displayState:(BTButtonState)state;

/// Called when the button is initially touched.
/// This is not the same as BTTouchListener.onTouchStart, which can be called multiple
/// times during a single "button press session", if the user is touching the screen
/// in multiple places.
- (void)handleInitialTouch:(SPTouch*)touch;

/// If the button is "mid-click" (it's been pressed but not released), this will
/// cancel the click process. (Does not change the button's display state.)
- (void)cancelInputCapture;

/// Sets the button state. The button calls this automatically in response to input.
- (void)setState:(BTButtonState)state;

@end