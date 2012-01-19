//
// Betwixt - Copyright 2011 Three Rings Design

#import "BTAlphaTask.h"

@implementation BTAlphaTask {
    float _startAlpha;
    float _deltaAlpha;
}

- (id)initOverTime:(float)seconds toAlpha:(float)alpha {
    return [self initOverTime:seconds toAlpha:alpha withInterpolator:BTLinearInterpolator];
}

- (id)initOverTime:(float)seconds toAlpha:(float)alpha withInterpolator:(BTInterpolator)interp {
    return [self initOverTime:seconds toAlpha:alpha withInterpolator:interp onDisplay:nil];
}

- (id)initOverTime:(float)seconds toAlpha:(float)alpha onDisplay:(SPDisplayObject*)display {
    return [self initOverTime:seconds toAlpha:alpha withInterpolator:BTLinearInterpolator onDisplay:display];
}

- (id)initOverTime:(float)seconds toAlpha:(float)alpha
  withInterpolator:(BTInterpolator)interp onDisplay:(SPDisplayObject*)display {
    if (!(self = [super initOverTime:seconds withInterpolator:interp onDisplay:display])) return nil;
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
