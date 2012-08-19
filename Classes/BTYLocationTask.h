//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObjectTask.h"

@protocol BTHasLocation;

/// Animates the Y component of the given node's location
@interface BTYLocationTask : BTInterpolationTask {
@protected
    float _startY;
    float _endY;
    __weak id<BTHasLocation> _target;
}

+ (BTYLocationTask*)withTime:(float)seconds toY:(float)y;
+ (BTYLocationTask*)withTime:(float)seconds toY:(float)y interpolator:(id<OOOInterpolator>)interp;
+ (BTYLocationTask*)withTime:(float)seconds toY:(float)y target:(id<BTHasLocation>)target;
+ (BTYLocationTask*)withTime:(float)seconds toY:(float)y interpolator:(id<OOOInterpolator>)interp target:(id<BTHasLocation>)target;

- (id)initWithTime:(float)seconds toY:(float)y interpolator:(id<OOOInterpolator>)interp target:(id<BTHasLocation>)target;
@end
