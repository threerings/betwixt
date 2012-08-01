//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTRotationTask.h"
#import "BTInterpolationTask+Protected.h"
#import "BTNode+Protected.h"

@implementation BTRotationTask

+ (BTRotationTask*)withTime:(float)seconds rotation:(float)rads {
    return [[BTRotationTask alloc] initWithTime:seconds rotation:rads interpolator:OOOEasing.linear target:nil];
}

+ (BTRotationTask*)withTime:(float)seconds rotation:(float)rads interpolator:(id<OOOInterpolator>)interp {
    return [[BTRotationTask alloc] initWithTime:seconds rotation:rads interpolator:interp target:nil];
}

+ (BTRotationTask*)withTime:(float)seconds rotation:(float)rads target:(SPDisplayObject*)target {
    return [[BTRotationTask alloc] initWithTime:seconds rotation:rads interpolator:OOOEasing.linear target:target];
}

+ (BTRotationTask*)withTime:(float)seconds rotation:(float)rads interpolator:(id<OOOInterpolator>)interp
                      target:(SPDisplayObject*)target {
    return [[BTRotationTask alloc] initWithTime:seconds rotation:rads interpolator:interp target:target];
}

- (id)initWithTime:(float)seconds rotation:(float)rads interpolator:(id<OOOInterpolator>)interp target:(SPDisplayObject*)target {
    if ((self = [super initWithTime:seconds interpolator:interp target:target])) {
        _endRotation = rads;
    }
    return self;
}

- (void)added {
    [super added];
    _startRotation = _target.rotation;
}

- (void)updateValues {
    _target.rotation = [self interpolate:_startRotation to:_endRotation];
}

@end
