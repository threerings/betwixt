//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTScaleTask.h"
#import "OOOEasing.h"
#import "BTInterpolationTask+Protected.h"

@implementation BTScaleTask

+ (BTScaleTask*)withTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY {
    return [[BTScaleTask alloc] initWithTime:seconds scaleX:scaleX scaleY:scaleY];
}

+ (BTScaleTask*)withTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY 
             interpolator:(id<OOOInterpolator>)interp {
    return [[BTScaleTask alloc] initWithTime:seconds scaleX:scaleX scaleY:scaleY interpolator:interp];
}

+ (BTScaleTask*)withTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY 
                   target:(SPDisplayObject*)target {
    return [[BTScaleTask alloc] initWithTime:seconds scaleX:scaleX scaleY:scaleY target:target];
}

+ (BTScaleTask*)withTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY 
             interpolator:(id<OOOInterpolator>)interp target:(SPDisplayObject*)target {
    return [[BTScaleTask alloc] initWithTime:seconds scaleX:scaleX scaleY:scaleY interpolator:interp target:target];
}

- (id)initWithTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY {
    return [self initWithTime:seconds scaleX:(float)scaleX scaleY:(float)scaleY 
                 interpolator:OOOEasing.linear target:nil];
}

- (id)initWithTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY 
      interpolator:(id<OOOInterpolator>)interp {
    return [self initWithTime:seconds scaleX:(float)scaleX scaleY:(float)scaleY interpolator:interp 
                       target:nil];
}

- (id)initWithTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY 
            target:(SPDisplayObject*)target {
    return [self initWithTime:seconds scaleX:(float)scaleX scaleY:(float)scaleY 
                 interpolator:OOOEasing.linear target:target];
}

- (id)initWithTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY 
      interpolator:(id<OOOInterpolator>)interp target:(SPDisplayObject*)target {
    if ((self = [super initWithTime:seconds interpolator:interp target:target])) {
        _endX = scaleX;
        _endY = scaleY;
    }
    return self;
}

- (void)added {
    [super added];
    _startX = _target.scaleX;
    _startY = _target.scaleY;
}

- (void)updateValues {
    _target.scaleX = [self interpolate:_startX to:_endX];
    _target.scaleY = [self interpolate:_startY to:_endY];
}

@end
