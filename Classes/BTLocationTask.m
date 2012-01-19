//
// Betwixt - Copyright 2011 Three Rings Design

#import "BTLocationTask.h"

@implementation BTLocationTask {
    float _startX;
    float _startY;
    float _deltaX;
    float _deltaY;
}

- (id)initOverTime:(float)seconds toX:(float)x toY:(float)y {
    return [self initOverTime:seconds toX:x toY:x withInterpolator:BTLinearInterpolator];
}

- (id)initOverTime:(float)seconds toX:(float)x toY:(float)y withInterpolator:(BTInterpolator)interp {
    return [self initOverTime:seconds toX:x toY:y withInterpolator:interp onDisplay:nil];
}

- (id)initOverTime:(float)seconds toX:(float)x toY:(float)y onDisplay:(SPDisplayObject*)display {
    return [self initOverTime:seconds toX:x toY:y withInterpolator:BTLinearInterpolator
                    onDisplay:display];
}

- (id)initOverTime:(float)seconds toX:(float)x toY:(float)y
  withInterpolator:(BTInterpolator)interp onDisplay:(SPDisplayObject*)display {
    if (!(self = [super initOverTime:seconds withInterpolator:interp onDisplay:display])) return nil;
    [self.attached connectUnit:^{
        _startX = _target.x;
        _startY = _target.y;
        _deltaX = x - _startX;
        _deltaY = y - _startY;
    }];
    return self;
}

-(void) updateInterpolatedTo:(float)interpolated {
    _target.x = _startX + _deltaX * interpolated;
    _target.y = _startY + _deltaY * interpolated;
}
@end
