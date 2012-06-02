//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTViewObject.h"
#import "BTNode+Protected.h"
#import "BTTouchable.h"

@interface BTSimpleDisplayObject : BTViewObject {
@private
    SPDisplayObject* _disp;
}
- (id)initWithDisplayObject:(SPDisplayObject*)disp;
@end

@interface BTViewObject () {
@protected
    BTTouchableDisplayObject* _touchable;
}
@property (nonatomic,readonly) BTTouchableDisplayObject* touchable;
@end

@implementation BTViewObject

- (BTTouchableDisplayObject*)touchable {
    if (_touchable == nil) {
        _touchable = [[BTTouchableDisplayObject alloc] initWithDisplayObject:self.display];
    }
    return _touchable;
}

- (BTEventSignal*)touchEvent {
    return self.touchable.touchEvent;
}

- (RAObjectSignal*)touchBegan {
    return self.touchable.touchBegan;
}

- (RAObjectSignal*)touchMoved {
    return self.touchable.touchMoved;
}

- (RAObjectSignal*)touchStationary {
    return self.touchable.touchStationary;
}

- (RAObjectSignal*)touchEnded {
    return self.touchable.touchEnded;
}

- (RAObjectSignal*)touchCanceled {
    return self.touchable.touchCanceled;
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

+ (BTViewObject*)viewObjectWithDisplay:(SPDisplayObject *)disp {
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
