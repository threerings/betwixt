//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTScaleTask.h"

@implementation BTScaleTask {
    float _startX;
    float _startY;
    float _deltaX;
    float _deltaY;
}

+ (BTScaleTask *)withTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY {
    return [[BTScaleTask alloc] initWithTime:seconds scaleX:scaleX scaleY:scaleY];
}

+ (BTScaleTask *)withTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY 
             interpolator:(BTInterpolator)interp {
    return [[BTScaleTask alloc] initWithTime:seconds scaleX:scaleX scaleY:scaleY interpolator:interp];
}

+ (BTScaleTask *)withTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY 
                   target:(SPDisplayObject *)target {
    return [[BTScaleTask alloc] initWithTime:seconds scaleX:scaleX scaleY:scaleY target:target];
}

+ (BTScaleTask *)withTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY 
             interpolator:(BTInterpolator)interp target:(SPDisplayObject *)target {
    return [[BTScaleTask alloc] initWithTime:seconds scaleX:scaleX scaleY:scaleY interpolator:interp target:target];
}

- (id)initWithTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY {
    return [self initWithTime:seconds scaleX:(float)scaleX scaleY:(float)scaleY 
                 interpolator:BTLinearInterpolator target:nil];
}

- (id)initWithTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY 
      interpolator:(BTInterpolator)interp {
    return [self initWithTime:seconds scaleX:(float)scaleX scaleY:(float)scaleY interpolator:interp 
                       target:nil];
}

- (id)initWithTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY 
            target:(SPDisplayObject *)target {
    return [self initWithTime:seconds scaleX:(float)scaleX scaleY:(float)scaleY 
                 interpolator:BTLinearInterpolator target:target];
}

- (id)initWithTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY 
      interpolator:(BTInterpolator)interp target:(SPDisplayObject *)target {
    if (!(self = [super initWithTime:seconds interpolator:interp target:target])) return nil;
    [self.attached connectUnit:^{
        _startX = _target.x;
        _startY = _target.y;
        _deltaX = scaleX - _startX;
        _deltaY = scaleY - _startY;
    }];
    return self;
}
- (void)updateInterpolatedTo:(float)interpolated {
    _target.scaleX = _startX + _deltaX * interpolated;
    _target.scaleY = _startY + _deltaY * interpolated;
}


@end
