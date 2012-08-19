//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObjectTask.h"

@protocol BTHasLocation;

/// Animates the X component of the given node's location
@interface BTXLocationTask : BTInterpolationTask {
@protected
    float _startX;
    float _endX;
    __weak id<BTHasLocation> _target;
}

+ (BTXLocationTask*)withTime:(float)seconds toX:(float)x;
+ (BTXLocationTask*)withTime:(float)seconds toX:(float)x interpolator:(id<OOOInterpolator>)interp;
+ (BTXLocationTask*)withTime:(float)seconds toX:(float)x target:(id<BTHasLocation>)target;
+ (BTXLocationTask*)withTime:(float)seconds toX:(float)x interpolator:(id<OOOInterpolator>)interp target:(id<BTHasLocation>)target;

- (id)initWithTime:(float)seconds toX:(float)x interpolator:(id<OOOInterpolator>)interp target:(id<BTHasLocation>)target;
@end
