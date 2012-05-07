//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTButton.h"
#import "BTButton+Protected.h"
#import "BTNode+Protected.h"
#import "BTDisplayObjectButton.h"
#import "BTMovieButton.h"
#import "BTMovieResource.h"
#import "BTMode.h"

@interface BTButton () {
    BTButtonState _curState;
}

- (void)setState:(BTButtonState)state;
- (BOOL)hitTest:(SPTouch*)touch;
- (void)cancelCapture;
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
    if (!(self = [super init])) {
        return nil;
    }
    _clicked = [[RAUnitSignal alloc] init];
    _enabled = YES;
    return self;
}

- (void)attached {
    [super attached];
    
    _curState = (BTButtonState) -1;
    [self setState:BT_BUTTON_STATE_UP];
    // Force the enabling logic
    _enabled = !_enabled;
    self.enabled = !_enabled;
    
    [self.conns addConnection:[self.touchBegan connectSlot:^(SPTouch* touch) {
        if (_enabled) {
            _touch = touch;
            [self setState:BT_BUTTON_STATE_DOWN];
            // capture all input until the touch ends
            _captureReg = [self.mode.input registerListener:self];
        }
    }]];
}

- (void)cleanup {
    [self cancelCapture];
}

- (BOOL)onTouchStart:(SPTouch*)touch {
    return YES;
}

- (BOOL)onTouchMove:(SPTouch*)touch {
    if (!_enabled) {
        return NO;
    }
    if (touch == _touch) {
        [self setState:[self hitTest:touch] ? BT_BUTTON_STATE_DOWN : BT_BUTTON_STATE_UP];
    }
    return YES;
}

- (BOOL)onTouchEnd:(SPTouch*)touch {
    if (!_enabled) {
        return NO;
    }
    if (_touch == touch) {
        [self setState:BT_BUTTON_STATE_UP];
        [self cancelCapture];
        // Emit the signal after doing everything else, because a
        // signal handler could change our state.
        if ([self hitTest:touch]) {
            [_clicked emit];
        }
    }
    return YES;
}

- (void)cancelCapture {
    [_captureReg cancel];
    _captureReg = nil;
    _touch = nil;
}

- (void)setEnabled:(BOOL)enabled {
    if (_enabled == enabled) {
        return;
    }
    _enabled = enabled;
    _sprite.touchable = _enabled;
    [self setState:(_enabled ? BT_BUTTON_STATE_UP : BT_BUTTON_STATE_DISABLED)];
}

- (void)setState:(BTButtonState)state {
    if (_curState == state) {
        return;
    }
    _curState = state;
    [self displayState:_curState];
}

- (void)displayState:(BTButtonState)state {
    [self doesNotRecognizeSelector:_cmd];
}

- (SPRectangle*)clickBounds {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (BOOL)hitTest:(SPTouch*)touch {
    return [self.clickBounds containsPoint:
            [_sprite globalToLocal:[SPPoint pointWithX:touch.globalX y:touch.globalY]]];
}
             

@end
