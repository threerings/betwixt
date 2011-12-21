//
// Betwixt - Copyright 2011 Three Rings Design

#import "BTInterpolationTask.h"
#import "BTMode.h"
#import "BTDisplayable.h"

@implementation BTInterpolationTask {
    double _elapsedTime;
    double _totalTime;
    BTInterpolator _interpolator;
}
- (id)initOverTime:(double)seconds withInterpolator:(BTInterpolator)interp
         onDisplay:(SPDisplayObject*)display {
    if (!(self = [super init])) return nil;
    _target = display;
    _totalTime = seconds;
    _interpolator = interp;
    [self.attached connectUnit:^{
        if (_target == nil) {
            _target = ((id<BTDisplayable>)self.parent).display;
        }
        [self.root.enterFrame connectSlot:^(double timePassed){
            _elapsedTime += timePassed;
            if (_elapsedTime > _totalTime) _elapsedTime = _totalTime;
            [self updateInterpolatedTo:_interpolator(_elapsedTime / _totalTime)];
            if (_elapsedTime == _totalTime) [self detach];
        }];
    }];
    return self;
}

-(void) updateInterpolatedTo:(float)interpolated {}
@end
