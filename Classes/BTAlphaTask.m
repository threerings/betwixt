//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTAlphaTask.h"
#import "BTInterpolationTask+Protected.h"
#import "BTInterpolator.h"

@implementation BTAlphaTask

+ (BTAlphaTask*)withTime:(float)seconds alpha:(float)alpha {
    return [[BTAlphaTask alloc] initWithTime:seconds alpha:alpha];
}

+ (BTAlphaTask*)withTime:(float)seconds alpha:(float)alpha interpolator:(BTInterpolator*)interp {
    return [[BTAlphaTask alloc] initWithTime:seconds alpha:alpha interpolator:interp];
}

+ (BTAlphaTask*)withTime:(float)seconds alpha:(float)alpha target:(SPDisplayObject*)target {
    return [[BTAlphaTask alloc] initWithTime:seconds alpha:alpha target:target];
}

+ (BTAlphaTask*)withTime:(float)seconds alpha:(float)alpha interpolator:(BTInterpolator*)interp 
        target:(SPDisplayObject*)target {
    return [[BTAlphaTask alloc] initWithTime:seconds alpha:alpha interpolator:interp target:target];
}

- (id)initWithTime:(float)seconds alpha:(float)alpha {
    return [self initWithTime:seconds alpha:alpha interpolator:BTInterpolator.LINEAR target:nil];
}

- (id)initWithTime:(float)seconds alpha:(float)alpha interpolator:(BTInterpolator*)interp {
    return [self initWithTime:seconds alpha:alpha interpolator:interp target:nil];
}

- (id)initWithTime:(float)seconds alpha:(float)alpha target:(SPDisplayObject*)target {
    return [self initWithTime:seconds alpha:alpha interpolator:BTInterpolator.LINEAR target:target];
}

- (id)initWithTime:(float)seconds alpha:(float)alpha interpolator:(BTInterpolator*)interp target:(SPDisplayObject*)target {
    if (!(self = [super initWithTime:seconds interpolator:interp target:target])) return nil;
    _endAlpha = alpha;
    return self;
}

- (void)attached {
    [super attached];
    _startAlpha = _target.alpha;
}

- (void)updateValues {
    _target.alpha = [self interpolate:_startAlpha to:_endAlpha];
}
@end
