//
// nod - Copyright 2012 Three Rings Design

#import "BTSprite.h"
#import "BTInput.h"

@interface BTButton : BTSprite <BTTouchListener> {
@protected
    RAUnitSignal* _clicked;
    BTInputRegistration* _captureReg;
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
