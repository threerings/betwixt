//
// nod - Copyright 2012 Three Rings Design

#import "BTDisplayObjectButton.h"
#import "BTButton+Protected.h"

@implementation BTDisplayObjectButton

- (id)initWithUpState:(SPDisplayObject*)upState downState:(SPDisplayObject*)downState 
        disabledState:(SPDisplayObject*)disabledState {
    if (!(self = [super init])) {
        return nil;
    }
    _upState = upState;
    _downState = downState;
    _disabledState = disabledState;
    _clickBounds = [_upState bounds];
    return self;
}

- (void)displayState:(BTButtonState)state {
    if (_curStateDisp != nil) {
        [_curStateDisp removeFromParent];
        _curStateDisp = nil;
    }
    switch (state) {
    case BT_BUTTON_STATE_UP: _curStateDisp = _upState; break;
    case BT_BUTTON_STATE_DOWN: _curStateDisp = _downState; break;
    case BT_BUTTON_STATE_DISABLED: _curStateDisp = _disabledState; break;
    }
    if (_curStateDisp != nil) {
        [_sprite addChild:_curStateDisp];
    }
}

- (SPRectangle*)clickBounds {
    return _clickBounds;
}

@end