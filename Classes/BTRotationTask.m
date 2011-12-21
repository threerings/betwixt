//
// Betwixt - Copyright 2011 Three Rings Design

#import "BTRotationTask.h"

@implementation BTRotationTask {
    float _startRotation;
    float _deltaRotation;
}
- (id)initOverTime:(double)seconds toRotation:(float)rads {
    return [self initOverTime:seconds toRotation:rads withInterpolator:BTLinearInterpolator];
}

- (id)initOverTime:(double)seconds toRotation:(float)rads withInterpolator:(BTInterpolator)interp {
    return [self initOverTime:seconds toRotation:rads withInterpolator:interp onDisplay:nil];
}

- (id)initOverTime:(double)seconds toRotation:(float)rads onDisplay:(SPDisplayObject*)display {
    return [self initOverTime:seconds toRotation:rads withInterpolator:BTLinearInterpolator
                onDisplay:display];
}

- (id)initOverTime:(double)seconds toRotation:(float)rads
  withInterpolator:(BTInterpolator)interp onDisplay:(SPDisplayObject*)display {
    if (!(self = [super initOverTime:seconds withInterpolator:interp onDisplay:display])) return nil;
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
