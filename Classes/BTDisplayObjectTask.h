//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTInterpolationTask.h"

@interface BTDisplayObjectTask : BTInterpolationTask {
@protected
    __weak SPDisplayObject* _target;
}

- (id)initWithTime:(float)seconds interpolator:(id<OOOInterpolator>)interp
            target:(SPDisplayObject*)target;

@end
