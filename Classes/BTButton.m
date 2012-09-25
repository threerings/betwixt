//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTButton.h"
#import "BTButton+Protected.h"
#import "BTNode+Protected.h"
#import "BTDisplayObjectButton.h"
#import "BTMovieButton.h"
#import "BTMovieResource.h"
#import "BTMode.h"

@interface BTButton ()
- (BOOL)hitTest:(SPTouch*)touch;
@end

@implementation BTButton

@synthesize enabled = _enabled;
@synthesize clicked = _clicked;

+ (BTButton*)buttonWithUpState:(SPDisplayObject*)upState
                     downState:(SPDisplayObject*)downState
                 disabledState:(SPDisplayObject*)disabledState;
{
    return [[BTDisplayObjectButton alloc] initWithUpState:upState
                                                downState:downState
                                            disabledState:disabledState];
}

+ (BTButton*)buttonWithMovie:(NSString*)movieName {
    return [[BTMovieButton alloc] initWithMovie:[BTMovieResource newMovie:movieName]];
}

- (id)init {
    if ((self = [super init])) {
        _clicked = [[RAUnitSignal alloc] init];
        _enabled = YES;
    }
    return self;
}

- (void)added {
    [super added];

    _curState = (BTButtonState) -1;
    [self setState:BT_ButtonUp];
    // Force the enabling logic
    _enabled = !_enabled;
    self.enabled = !_enabled;

    [self.conns addConnection:[self.touchBegan connectSlot:^(SPTouch* touch) {
        if (_enabled) {
            [self handleInitialTouch:touch];
        }
    }]];
}

- (void)cleanup {
    [self cancelInputCapture];
    [super cleanup];
}

- (void)handleInitialTouch:(SPTouch*)touch {
    _touch = touch;
    [self setState:BT_ButtonDown];
    // capture all input until the touch ends
    _captureReg = [self.mode.input registerListener:self];
}

- (BTTouchStatus)onTouchStart:(SPTouch*)touch {
    return BTTouch_Handled;
}

- (BTTouchStatus)onTouchMove:(SPTouch*)touch {
    if (!_enabled) {
        return BTTouch_Unhandled;
    }
    if (touch == _touch) {
        [self setState:[self hitTest:touch] ? BT_ButtonDown : BT_ButtonUp];
    }
    return BTTouch_Handled;
}

- (BTTouchStatus)onTouchEnd:(SPTouch*)touch {
    if (!_enabled) {
        return BTTouch_Unhandled;
    }
    if (_touch == touch) {
        [self setState:BT_ButtonUp];
        [self cancelInputCapture];
        // Emit the signal after doing everything else, because a
        // signal handler could change our state.
        if ([self hitTest:touch]) {
            [_clicked emit];
        }
    }
    return BTTouch_Handled;
}

- (void)cancelInputCapture {
    [_captureReg cancel];
    _captureReg = nil;
    _touch = nil;
}

- (void)setEnabled:(BOOL)enabled {
    if (_enabled == enabled) {
        return;
    }
    _enabled = enabled;
    [self setState:(_enabled ? BT_ButtonUp : BT_ButtonDisabled)];
}

- (void)setState:(BTButtonState)state {
    if (_curState == state) {
        return;
    }
    _curState = state;
    [self displayState:_curState];
}

- (void)displayState:(BTButtonState)state {
    OOO_IS_ABSTRACT();
}

- (SPRectangle*)clickBounds {
    OOO_IS_ABSTRACT();
    return nil;
}

- (BOOL)hitTest:(SPTouch*)touch {
    return [self.clickBounds containsPoint:
            [_sprite globalToLocal:[SPPoint pointWithX:touch.globalX y:touch.globalY]]];
}


@end
