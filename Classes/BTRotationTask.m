//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTRotationTask.h"

@implementation BTRotationTask {
    float _startRotation;
    float _deltaRotation;
}
- (id)initWithTime:(float)seconds rotation:(float)rads {
    return [self initWithTime:seconds rotation:rads interpolator:BTLinearInterpolator];
}

- (id)initWithTime:(float)seconds rotation:(float)rads interpolator:(BTInterpolator)interp {
    return [self initWithTime:seconds rotation:rads interpolator:interp display:nil];
}

- (id)initWithTime:(float)seconds rotation:(float)rads display:(SPDisplayObject*)display {
    return [self initWithTime:seconds rotation:rads interpolator:BTLinearInterpolator
                display:display];
}

- (id)initWithTime:(float)seconds rotation:(float)rads
  interpolator:(BTInterpolator)interp display:(SPDisplayObject*)display {
    if (!(self = [super initWithTime:seconds interpolator:interp display:display])) return nil;
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
