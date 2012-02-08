//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTRotationTask.h"

@implementation BTRotationTask {
    float _startRotation;
    float _deltaRotation;
}

+ (BTRotationTask *)withTime:(float)seconds rotation:(float)rads {
    return [[BTRotationTask alloc] initWithTime:seconds rotation:rads];
}

+ (BTRotationTask *)withTime:(float)seconds rotation:(float)rads interpolator:(BTInterpolator)interp {
    return [[BTRotationTask alloc] initWithTime:seconds rotation:rads interpolator:interp];
}

+ (BTRotationTask *)withTime:(float)seconds rotation:(float)rads target:(SPDisplayObject*)target {
    return [[BTRotationTask alloc] initWithTime:seconds rotation:rads target:target];
}

+ (BTRotationTask *)withTime:(float)seconds rotation:(float)rads interpolator:(BTInterpolator)interp 
                      target:(SPDisplayObject*)target {
    return [[BTRotationTask alloc] initWithTime:seconds rotation:rads interpolator:interp target:target];
}

- (id)initWithTime:(float)seconds rotation:(float)rads {
    return [self initWithTime:seconds rotation:rads interpolator:BTLinearInterpolator target:nil];
}

- (id)initWithTime:(float)seconds rotation:(float)rads interpolator:(BTInterpolator)interp {
    return [self initWithTime:seconds rotation:rads interpolator:interp target:nil];
}

- (id)initWithTime:(float)seconds rotation:(float)rads target:(SPDisplayObject*)target {
    return [self initWithTime:seconds rotation:rads interpolator:BTLinearInterpolator
                target:target];
}

- (id)initWithTime:(float)seconds rotation:(float)rads
  interpolator:(BTInterpolator)interp target:(SPDisplayObject*)target {
    if (!(self = [super initWithTime:seconds interpolator:interp target:target])) return nil;
    [self.attached connectUnit:^{
        _startRotation = _target.rotation;
        _deltaRotation = rads - _startRotation;
    }];
    return self;
}

-(void) updateInterpolatedTo:(float)interpolated {
    _target.rotation = _startRotation + _deltaRotation * interpolated;
}

@end
