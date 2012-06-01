//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTViewObject.h"
#import "BTNode+Protected.h"
#import "BTTouchEventSignals.h"

@interface BTSimpleDisplayObject : BTViewObject {
@private
    SPDisplayObject* _disp;
}
- (id)initWithDisplayObject:(SPDisplayObject*)disp;
@end

@interface BTViewObject () {
@protected
    BTTouchEventSignals* _touchEventSignals;
}
@property (nonatomic,readonly) BTTouchEventSignals* touchEventSignals;
@end

@implementation BTViewObject

- (BTTouchEventSignals*)touchEventSignals {
    if (_touchEventSignals == nil) {
        _touchEventSignals = [[BTTouchEventSignals alloc] initWithDisplayObject:self.display];
    }
    return _touchEventSignals;
}

- (BTEventSignal*)touchEvent {
    return self.touchEventSignals.touchEvent;
}

- (RAObjectSignal*)touchBegan {
    return self.touchEventSignals.touchBegan;
}

- (RAObjectSignal*)touchMoved {
    return self.touchEventSignals.touchMoved;
}

- (RAObjectSignal*)touchStationary {
    return self.touchEventSignals.touchStationary;
}

- (RAObjectSignal*)touchEnded {
    return self.touchEventSignals.touchEnded;
}

- (RAObjectSignal*)touchCanceled {
    return self.touchEventSignals.touchCanceled;
}

- (float)x {
    return self.display.x;
}

- (float)y {
    return self.display.y;
}

- (void)setX:(float)x {
    self.display.x = x;
}

- (void)setY:(float)y {
    self.display.y = y;
}

- (SPPoint*)loc {
    return [SPPoint pointWithX:self.x y:self.y];
}

- (void)setLoc:(SPPoint*)loc {
    self.x = loc.x;
    self.y = loc.y;
}

- (SPDisplayObject*)display {
    OOO_IS_ABSTRACT();
    return nil;
}

- (void)cleanup {
    [self.display removeFromParent];
    [super cleanup];
}

+ (BTViewObject*)create:(SPDisplayObject*)disp {
    return [[BTSimpleDisplayObject alloc] initWithDisplayObject:disp];
}

@end

@implementation BTSimpleDisplayObject

@synthesize display = _disp;

- (id)initWithDisplayObject:(SPDisplayObject*)disp {
    if ((self = [super init])) {
        _disp = disp;
    }
    return self;
}

@end
