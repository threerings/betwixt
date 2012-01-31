//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTLocationTask.h"

@implementation BTLocationTask {
    float _startX;
    float _startY;
    float _deltaX;
    float _deltaY;
}

- (id)initWithTime:(float)seconds toX:(float)x toY:(float)y {
    return [self initWithTime:seconds toX:x toY:x interpolator:BTLinearInterpolator];
}

- (id)initWithTime:(float)seconds toX:(float)x toY:(float)y interpolator:(BTInterpolator)interp {
    return [self initWithTime:seconds toX:x toY:y interpolator:interp display:nil];
}

- (id)initWithTime:(float)seconds toX:(float)x toY:(float)y display:(SPDisplayObject*)display {
    return [self initWithTime:seconds toX:x toY:y interpolator:BTLinearInterpolator
                    display:display];
}

- (id)initWithTime:(float)seconds toX:(float)x toY:(float)y interpolator:(BTInterpolator)interp 
           display:(SPDisplayObject*)display {
    if (!(self = [super initWithTime:seconds interpolator:interp display:display])) return nil;
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
