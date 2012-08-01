//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTButton.h"

@interface BTDisplayObjectButton : BTButton {
@protected
    SPDisplayObject* _upState;
    SPDisplayObject* _downState;
    SPDisplayObject* _disabledState;
    SPDisplayObject* _curStateDisp;
    SPRectangle* _clickBounds;
}

- (id)initWithUpState:(SPDisplayObject*)upState
            downState:(SPDisplayObject*)downState
        disabledState:(SPDisplayObject*)disabledState;

@end
