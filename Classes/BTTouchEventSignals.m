//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTTouchEventSignals.h"
#import "BTEventSignal.h"

@interface FilteredTouchSignal : RAObjectSignal
- (id)initWithTouchEventSignal:(BTEventSignal*)touchEvent phase:(SPTouchPhase)phase;
@end

@implementation FilteredTouchSignal

- (id)initWithTouchEventSignal:(BTEventSignal*)touchEvent phase:(SPTouchPhase)phase {
    if ((self = [super init])) {
        __weak SPDisplayObject* disp = (SPDisplayObject*)touchEvent.dispatcher;
        __weak FilteredTouchSignal* this = self;
        [touchEvent connectSlot:^(SPTouchEvent* event) {
            if (!this || !disp) {
                return;
            }
            SPTouch* touch = [[event touchesWithTarget:disp andPhase:phase] anyObject];
            if (touch != nil) {
                [this emitEvent:touch];
            }
        }];
    }
    
    return self;
}

@end

@interface BTTouchEventSignals () {
    // these are all lazily initialized
    FilteredTouchSignal* _touchBegan;
    FilteredTouchSignal* _touchMoved;
    FilteredTouchSignal* _touchStationary;
    FilteredTouchSignal* _touchEnded;
    FilteredTouchSignal* _touchCanceled;
}
@end

@implementation BTTouchEventSignals

@synthesize touchEvent = _touchEvent;

- (id)initWithDisplayObject:(SPDisplayObject*)disp {
    if ((self = [super init])) {
        _touchEvent = [[BTEventSignal alloc] initWithDispatcher:disp eventType:SP_EVENT_TYPE_TOUCH];
    }
    return self;
}

- (RAObjectSignal*)touchBegan {
    if (_touchBegan == nil) {
        _touchBegan = [[FilteredTouchSignal alloc] initWithTouchEventSignal:_touchEvent 
                                                                      phase:SPTouchPhaseBegan];
    }
    return _touchBegan;
}

- (RAObjectSignal*)touchMoved {
    if (_touchMoved == nil) {
        _touchMoved = [[FilteredTouchSignal alloc] initWithTouchEventSignal:_touchEvent 
                                                                      phase:SPTouchPhaseMoved];
    }
    return _touchMoved;
}

- (RAObjectSignal*)touchStationary {
    if (_touchStationary == nil) {
        _touchStationary = [[FilteredTouchSignal alloc] initWithTouchEventSignal:_touchEvent 
                                                                           phase:SPTouchPhaseStationary];
    }
    return _touchStationary;
}

- (RAObjectSignal*)touchEnded {
    if (_touchEnded == nil) {
        _touchEnded = [[FilteredTouchSignal alloc] initWithTouchEventSignal:_touchEvent 
                                                                           phase:SPTouchPhaseEnded];
    }
    return _touchEnded;
}

- (RAObjectSignal*)touchCanceled {
    if (_touchCanceled == nil) {
        _touchCanceled = [[FilteredTouchSignal alloc] initWithTouchEventSignal:_touchEvent 
                                                                         phase:SPTouchPhaseCancelled];
    }
    return _touchCanceled;
}

@end
