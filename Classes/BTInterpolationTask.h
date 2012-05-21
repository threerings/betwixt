//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDurationTask.h"

@protocol OOOInterpolator;

@interface BTInterpolationTask : BTDurationTask {
@protected
    id<OOOInterpolator> _interpolator;
}

- (id)initWithTime:(float)seconds interpolator:(id<OOOInterpolator>)interp;
@end
