//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTScaleTask.h"
#import "BTInterpolator.h"
#import "BTInterpolationTask+Protected.h"

@implementation BTScaleTask {
    float _startX;
    float _startY;
    float _endX;
    float _endY;
}

+ (BTScaleTask*)withTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY {
    return [[BTScaleTask alloc] initWithTime:seconds scaleX:scaleX scaleY:scaleY];
}

+ (BTScaleTask*)withTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY 
             interpolator:(BTInterpolator*)interp {
    return [[BTScaleTask alloc] initWithTime:seconds scaleX:scaleX scaleY:scaleY interpolator:interp];
}

+ (BTScaleTask*)withTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY 
                   target:(SPDisplayObject*)target {
    return [[BTScaleTask alloc] initWithTime:seconds scaleX:scaleX scaleY:scaleY target:target];
}

+ (BTScaleTask*)withTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY 
             interpolator:(BTInterpolator*)interp target:(SPDisplayObject*)target {
    return [[BTScaleTask alloc] initWithTime:seconds scaleX:scaleX scaleY:scaleY interpolator:interp target:target];
}

- (id)initWithTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY {
    return [self initWithTime:seconds scaleX:(float)scaleX scaleY:(float)scaleY 
                 interpolator:BTInterpolator.LINEAR target:nil];
}

- (id)initWithTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY 
      interpolator:(BTInterpolator*)interp {
    return [self initWithTime:seconds scaleX:(float)scaleX scaleY:(float)scaleY interpolator:interp 
                       target:nil];
}

- (id)initWithTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY 
            target:(SPDisplayObject*)target {
    return [self initWithTime:seconds scaleX:(float)scaleX scaleY:(float)scaleY 
                 interpolator:BTInterpolator.LINEAR target:target];
}

- (id)initWithTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY 
      interpolator:(BTInterpolator*)interp target:(SPDisplayObject*)target {
    if (!(self = [super initWithTime:seconds interpolator:interp target:target])) return nil;
    
    _endX = scaleX;
    _endY = scaleY;
    return self;
}

- (void)attached {
    [super attached];
    _startX = _target.x;
    _startY = _target.y;
}

- (void)updateValues {
    _target.scaleX = [self interpolate:_startX to:_endX];
    _target.scaleY = [self interpolate:_startY to:_endY];
}

@end
