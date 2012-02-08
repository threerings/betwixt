//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTAlphaTask.h"

@implementation BTAlphaTask {
    float _startAlpha;
    float _deltaAlpha;
}

+ (BTAlphaTask *)withTime:(float)seconds alpha:(float)alpha {
    return [[BTAlphaTask alloc] initWithTime:seconds alpha:alpha];
}

+ (BTAlphaTask *)withTime:(float)seconds alpha:(float)alpha interpolator:(BTInterpolator)interp {
    return [[BTAlphaTask alloc] initWithTime:seconds alpha:alpha interpolator:interp];
}

+ (BTAlphaTask *)withTime:(float)seconds alpha:(float)alpha target:(SPDisplayObject*)target {
    return [[BTAlphaTask alloc] initWithTime:seconds alpha:alpha target:target];
}

+ (BTAlphaTask *)withTime:(float)seconds alpha:(float)alpha interpolator:(BTInterpolator)interp 
        target:(SPDisplayObject*)target {
    return [[BTAlphaTask alloc] initWithTime:seconds alpha:alpha interpolator:interp target:target];
}

- (id)initWithTime:(float)seconds alpha:(float)alpha {
    return [self initWithTime:seconds alpha:alpha interpolator:BTLinearInterpolator target:nil];
}

- (id)initWithTime:(float)seconds alpha:(float)alpha interpolator:(BTInterpolator)interp {
    return [self initWithTime:seconds alpha:alpha interpolator:interp target:nil];
}

- (id)initWithTime:(float)seconds alpha:(float)alpha target:(SPDisplayObject*)target {
    return [self initWithTime:seconds alpha:alpha interpolator:BTLinearInterpolator target:target];
}

- (id)initWithTime:(float)seconds alpha:(float)alpha
  interpolator:(BTInterpolator)interp target:(SPDisplayObject*)target {
    if (!(self = [super initWithTime:seconds interpolator:interp target:target])) return nil;
    [self.attached connectUnit:^{
        _startAlpha = _target.alpha;
        _deltaAlpha = alpha - _startAlpha;
    }];
    return self;
}

-(void) updateInterpolatedTo:(float)interpolated {
    _target.alpha = _startAlpha + _deltaAlpha * interpolated;
}
@end
