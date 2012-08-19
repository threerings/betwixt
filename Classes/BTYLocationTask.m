//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTYLocationTask.h"
#import "BTNode+Protected.h"
#import "BTInterpolationTask+Protected.h"
#import "BTHasLocation.h"
#import "BTViewObject.h"

@implementation BTYLocationTask

+ (BTYLocationTask*)withTime:(float)seconds toY:(float)y {
    return [[BTYLocationTask alloc] initWithTime:seconds toY:y interpolator:OOOEasing.linear target:nil];
}

+ (BTYLocationTask*)withTime:(float)seconds toY:(float)y interpolator:(id<OOOInterpolator>)interp {
    return [[BTYLocationTask alloc] initWithTime:seconds toY:y interpolator:interp target:nil];
}

+ (BTYLocationTask*)withTime:(float)seconds toY:(float)y target:(id<BTHasLocation>)target {
    return [[BTYLocationTask alloc] initWithTime:seconds toY:y interpolator:OOOEasing.linear target:target];
}

+ (BTYLocationTask*)withTime:(float)seconds toY:(float)y interpolator:(id<OOOInterpolator>)interp target:(id<BTHasLocation>)target {
    return [[BTYLocationTask alloc] initWithTime:seconds toY:y interpolator:interp target:target];
}

- (id)initWithTime:(float)seconds toY:(float)y interpolator:(id<OOOInterpolator>)interp
            target:(id<BTHasLocation>)target {
    if ((self = [super initWithTime:seconds interpolator:interp])) {
        _target = target;
        _endY = y;
    }

    return self;
}

- (void)added {
    [super added];
    if (_target == nil) {
        _target = ((BTViewObject*)self.parent).display;
    }
    _startY = _target.y;
}

- (void)updateValues {
    _target.y = [self interpolate:_startY to:_endY];
}

@end
