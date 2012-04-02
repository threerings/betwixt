//
// Betwixt - Copyright 2012 Three Rings Design

@class BTEventSignal;

@interface BTTouchEventSignals : NSObject {
@protected
    BTEventSignal* _touchEvent;
}

@property (nonatomic,readonly) BTEventSignal* touchEvent;  // <SPTouchEvent>
@property (nonatomic,readonly) RAObjectSignal* touchBegan; // <SPTouch>
@property (nonatomic,readonly) RAObjectSignal* touchMoved; // <SPTouch>
@property (nonatomic,readonly) RAObjectSignal* touchStationary; // <SPTouch>
@property (nonatomic,readonly) RAObjectSignal* touchEnded; // <SPTouch>
@property (nonatomic,readonly) RAObjectSignal* touchCanceled; // <SPTouch>

- (id)initWithDisplayObject:(SPDisplayObject*)disp;

@end
