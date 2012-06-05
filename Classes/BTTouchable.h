//
// Betwixt - Copyright 2012 Three Rings Design

@class BTEventSignal;

@protocol BTTouchable

@property (nonatomic,readonly) BTEventSignal* touchEvent;  // <SPTouchEvent>

- (RAObjectSignal*)signalForPhase:(SPTouchPhase)phase;

@property (nonatomic,readonly) RAObjectSignal* touchBegan; // <SPTouch>
@property (nonatomic,readonly) RAObjectSignal* touchMoved; // <SPTouch>
@property (nonatomic,readonly) RAObjectSignal* touchStationary; // <SPTouch>
@property (nonatomic,readonly) RAObjectSignal* touchEnded; // <SPTouch>
@property (nonatomic,readonly) RAObjectSignal* touchCanceled; // <SPTouch>

@end

/// Wraps an SPDisplayObject and provides touch signals for it
@interface BTTouchableDisplayObject : NSObject <BTTouchable> {
@protected
    BTEventSignal* _touchEvent;
}

- (id)initWithDisplayObject:(SPDisplayObject*)disp;
- (void)disconnectAll;

@end