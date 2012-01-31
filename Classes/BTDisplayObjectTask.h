//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTInterpolationTask.h"

@interface BTDisplayObjectTask : BTInterpolationTask {
@protected
    SPDisplayObject *_target;
}

- (id)initWithTime:(float)seconds interpolator:(BTInterpolator)interp 
           display:(SPDisplayObject*)display;

@end
