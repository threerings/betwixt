//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTXLocationTask.h"
#import "BTNode+Protected.h"
#import "BTInterpolationTask+Protected.h"
#import "BTHasLocation.h"
#import "BTViewObject.h"

@implementation BTXLocationTask

+ (BTXLocationTask*)withTime:(float)seconds toX:(float)x {
    return [[BTXLocationTask alloc] initWithTime:seconds toX:x interpolator:OOOEasing.linear target:nil];
}

+ (BTXLocationTask*)withTime:(float)seconds toX:(float)x interpolator:(id<OOOInterpolator>)interp {
    return [[BTXLocationTask alloc] initWithTime:seconds toX:x interpolator:interp target:nil];
}

+ (BTXLocationTask*)withTime:(float)seconds toX:(float)x target:(id<BTHasLocation>)target {
    return [[BTXLocationTask alloc] initWithTime:seconds toX:x interpolator:OOOEasing.linear target:target];
}

+ (BTXLocationTask*)withTime:(float)seconds toX:(float)x interpolator:(id<OOOInterpolator>)interp target:(id<BTHasLocation>)target {
    return [[BTXLocationTask alloc] initWithTime:seconds toX:x interpolator:interp target:target];
}

- (id)initWithTime:(float)seconds toX:(float)x interpolator:(id<OOOInterpolator>)interp
            target:(id<BTHasLocation>)target {
    if ((self = [super initWithTime:seconds interpolator:interp])) {
        _target = target;
        _endX = x;
    }

    return self;
}

- (void)added {
    [super added];
    if (_target == nil) {
        _target = ((BTViewObject*)self.parent).display;
    }
    _startX = _target.x;
}

- (void)updateValues {
    _target.x = [self interpolate:_startX to:_endX];
}

@end
