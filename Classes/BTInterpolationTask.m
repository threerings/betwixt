//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTInterpolationTask+Protected.h"

@implementation BTInterpolationTask

- (id)initWithTime:(float)seconds interpolator:(id<OOOInterpolator>)interp {
    if ((self = [super initWithTime:seconds])) {
        _interpolator = interp;
    }
    return self;
}

- (float)interpolate:(float)from to:(float)to {
    return [_interpolator interpolate:from to:to dt:_elapsedTime t:_totalTime];
}

@end
