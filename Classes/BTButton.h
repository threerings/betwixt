//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTSpriteObject.h"
#import "BTInput.h"

typedef enum {
    BT_ButtonUp = 0,
    BT_ButtonDown,
    BT_ButtonDisabled
} BTButtonState;

@interface BTButton : BTSpriteObject <BTTouchListener> {
@protected
    BTButtonState _curState;
    RAUnitSignal* _clicked;
    id<OOORegistration> _captureReg;
    SPTouch* _touch;

    BOOL _enabled;
}

@property (nonatomic,assign) BOOL enabled;
@property (nonatomic,readonly) RAUnitSignal* clicked;

+ (BTButton*)buttonWithUpState:(SPDisplayObject*)upState
                     downState:(SPDisplayObject*)downState
                 disabledState:(SPDisplayObject*)disabledState;

+ (BTButton*)buttonWithMovie:(NSString*)movieName;

@end
