//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTTouchable.h"
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

@interface BTTouchableDisplayObject () {
    NSMutableArray* _filteredTouchSignals;
}
@end

@implementation BTTouchableDisplayObject

@synthesize touchEvent = _touchEvent;

- (id)initWithDisplayObject:(SPDisplayObject*)disp {
    if ((self = [super init])) {
        _touchEvent = [[BTEventSignal alloc] initWithDispatcher:disp eventType:SP_EVENT_TYPE_TOUCH];
    }
    return self;
}

- (RAObjectSignal*)signalForPhase:(SPTouchPhase)phase {
    if (_filteredTouchSignals == nil) {
        // If this fails, then SPTouchPhase has been reordered and we need to cope
        OOO_STATIC_ASSERT(SPTouchPhaseCancelled == 4);
        const int COUNT = SPTouchPhaseCancelled + 1;
        _filteredTouchSignals = [NSMutableArray arrayWithCapacity:COUNT];
        for (int ii = 0; ii < COUNT; ++ii) {
            [_filteredTouchSignals addObject:[NSNull null]];
        }
    }

    RAObjectSignal* signal = OOONSNullToNil([_filteredTouchSignals objectAtIndex:phase]);
    if (signal == nil) {
        signal = [[FilteredTouchSignal alloc] initWithTouchEventSignal:_touchEvent phase:phase];
        [_filteredTouchSignals replaceObjectAtIndex:phase withObject:signal];
    }
    return signal;
}

- (void)disconnectAll {
    for (id obj in _filteredTouchSignals) {
        RAObjectSignal* sig = OOONSNullToNil(obj);
        if (sig != nil) {
            [sig disconnectAll];
        }
    }
    _filteredTouchSignals = nil;
}

- (RAObjectSignal*)touchBegan {
    return [self signalForPhase:SPTouchPhaseBegan];
}

- (RAObjectSignal*)touchMoved {
    return [self signalForPhase:SPTouchPhaseMoved];
}

- (RAObjectSignal*)touchStationary {
    return [self signalForPhase:SPTouchPhaseStationary];
}

- (RAObjectSignal*)touchEnded {
    return [self signalForPhase:SPTouchPhaseEnded];
}

- (RAObjectSignal*)touchCanceled {
    return [self signalForPhase:SPTouchPhaseCancelled];
}

@end
