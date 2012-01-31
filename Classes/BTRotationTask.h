//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObjectTask.h"

@interface BTRotationTask : BTDisplayObjectTask

- (id)initWithTime:(float)seconds rotation:(float)rads;
- (id)initWithTime:(float)seconds rotation:(float)rads interpolator:(BTInterpolator)interp;
- (id)initWithTime:(float)seconds rotation:(float)rads display:(SPDisplayObject*)display;
- (id)initWithTime:(float)seconds rotation:(float)rads interpolator:(BTInterpolator)interp 
           display:(SPDisplayObject*)display;
@end
