//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDurationTask.h"

@class BTInterpolator;

@interface BTInterpolationTask : BTDurationTask {
@protected
    BTInterpolator *_interpolator;
}

- (id)initWithTime:(float)seconds interpolator:(BTInterpolator *)interp;
@end
