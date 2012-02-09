//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObjectTask.h"

@interface BTRotationTask : BTDisplayObjectTask

+ (BTRotationTask*)withTime:(float)seconds rotation:(float)rads;
+ (BTRotationTask*)withTime:(float)seconds rotation:(float)rads interpolator:(BTInterpolator*)interp;
+ (BTRotationTask*)withTime:(float)seconds rotation:(float)rads target:(SPDisplayObject*)target;
+ (BTRotationTask*)withTime:(float)seconds rotation:(float)rads interpolator:(BTInterpolator*)interp 
            target:(SPDisplayObject*)target;

- (id)initWithTime:(float)seconds rotation:(float)rads;
- (id)initWithTime:(float)seconds rotation:(float)rads interpolator:(BTInterpolator*)interp;
- (id)initWithTime:(float)seconds rotation:(float)rads target:(SPDisplayObject*)target;
- (id)initWithTime:(float)seconds rotation:(float)rads interpolator:(BTInterpolator*)interp 
           target:(SPDisplayObject*)target;
@end
