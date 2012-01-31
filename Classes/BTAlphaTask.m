//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTAlphaTask.h"

@implementation BTAlphaTask {
    float _startAlpha;
    float _deltaAlpha;
}

- (id)initWithTime:(float)seconds alpha:(float)alpha {
    return [self initWithTime:seconds alpha:alpha interpolator:BTLinearInterpolator display:nil];
}

- (id)initWithTime:(float)seconds alpha:(float)alpha interpolator:(BTInterpolator)interp {
    return [self initWithTime:seconds alpha:alpha interpolator:interp display:nil];
}

- (id)initWithTime:(float)seconds alpha:(float)alpha display:(SPDisplayObject*)display {
    return [self initWithTime:seconds alpha:alpha interpolator:BTLinearInterpolator display:display];
}

- (id)initWithTime:(float)seconds alpha:(float)alpha
  interpolator:(BTInterpolator)interp display:(SPDisplayObject*)display {
    if (!(self = [super initWithTime:seconds interpolator:interp display:display])) return nil;
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
