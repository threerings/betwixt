//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTTouchEventSignals.h"
#import "BTEventSignal.h"

@interface FilteredTouchSignal : RAObjectSignal {
    __weak SPDisplayObject* _disp;
    SPTouchPhase _phase;
}
- (id)initWithTouchEventSignal:(BTEventSignal*)touchEvent phase:(SPTouchPhase)phase;
@end

@implementation FilteredTouchSignal
- (id)initWithTouchEventSignal:(BTEventSignal*)touchEvent phase:(SPTouchPhase)thePhase {
    if (!(self = [super init])) {
        return nil;
    }
    _disp = (SPDisplayObject*)touchEvent.dispatcher;
    _phase = thePhase;
    
    __weak FilteredTouchSignal* this = self;
    [touchEvent connectSlot:^(SPTouchEvent* event) {
        if (!this) {
            return;
        }
        SPTouch* touch = [[event touchesWithTarget:this->_disp andPhase:this->_phase] anyObject];
        if (touch != nil) {
            [this emitEvent:touch];
        }
    }];
    
    return self;
}

@end

@implementation BTTouchEventSignals {
    // these are all lazily initialized
    FilteredTouchSignal* _touchBegan;
    FilteredTouchSignal* _touchMoved;
    FilteredTouchSignal* _touchStationary;
    FilteredTouchSignal* _touchEnded;
    FilteredTouchSignal* _touchCanceled;
}

@synthesize touchEvent = _touchEvent;

- (id)initWithDisplayObject:(SPDisplayObject*)disp {
    if (!(self = [super init])) {
        return nil;
    }
    _touchEvent = [[BTEventSignal alloc] initWithDispatcher:disp eventType:SP_EVENT_TYPE_TOUCH];
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
