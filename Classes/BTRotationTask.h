//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObjectTask.h"

@interface BTRotationTask : BTDisplayObjectTask {
@protected
    float _startRotation;
    float _endRotation;
}

+ (BTRotationTask*)withTime:(float)seconds rotation:(float)rads;
+ (BTRotationTask*)withTime:(float)seconds rotation:(float)rads interpolator:(id<OOOInterpolator>)interp;
+ (BTRotationTask*)withTime:(float)seconds rotation:(float)rads target:(SPDisplayObject*)target;
+ (BTRotationTask*)withTime:(float)seconds rotation:(float)rads interpolator:(id<OOOInterpolator>)interp 
            target:(SPDisplayObject*)target;

- (id)initWithTime:(float)seconds rotation:(float)rads interpolator:(id<OOOInterpolator>)interp 
           target:(SPDisplayObject*)target;
@end
