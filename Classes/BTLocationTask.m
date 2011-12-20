//
// Betwixt - Copyright 2011 Three Rings Design

#import "BTLocationTask.h"
#import "BTGeneration.h"
#import "BTDisplayable.h"

@implementation BTLocationTask {
    SPDisplayObject *_target;
    double _elapsedTime;
    double _totalTime;
    float _startX;
    float _startY;
    float _deltaX;
    float _deltaY;

    BTInterpolator _interpolator;
}

- (id)initOverTime:(double)seconds toX:(float)x toY:(float)y {
    return [self initOverTime:seconds toX:x toY:x withInterpolator:BTLinearInterpolator];
}

- (id)initOverTime:(double)seconds toX:(float)x toY:(float)y withInterpolator:(BTInterpolator)interp {
    return [self initOverTime:seconds toX:x toY:y withInterpolator:interp onDisplay:nil];
}

- (id)initOverTime:(double)seconds toX:(float)x toY:(float)y onDisplay:(SPDisplayObject*)display {
    return [self initOverTime:seconds toX:x toY:y withInterpolator:BTLinearInterpolator
                    onDisplay:display];
}

- (id)initOverTime:(double)seconds toX:(float)x toY:(float)y
  withInterpolator:(BTInterpolator)interp onDisplay:(SPDisplayObject*)display {
    if (!(self = [super init])) return nil;
    _target = display;
    _totalTime = seconds;
    _interpolator = interp;
    [self.attached connectUnit:^{
        if (_target == nil) {
            _target = ((id<BTDisplayable>)self.parent).display;
            NSLog(@"Looking up display on %@ found %@", self.parent, _target);
        } else {
            NSLog(@"Had passed in display %@ on %@", _target, self.parent);
        }
        _startX = _target.x;
        _startY = _target.y;
        _deltaX = x - _startX;
        _deltaY = y - _startY;
        [self.root.enterFrame connectSlot:^(double timePassed){
            _elapsedTime += timePassed;
            if (_elapsedTime > _totalTime) _elapsedTime = _totalTime;
            float ratio = _elapsedTime / _totalTime;
            float interpolated = _interpolator(ratio);
            _target.x = _startX + _deltaX * interpolated;
            _target.y = _startY + _deltaY * interpolated;
            if (_elapsedTime == _totalTime) [self detach];
        }];
    }];
    return self;
}
@end
