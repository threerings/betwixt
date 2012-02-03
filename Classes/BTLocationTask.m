//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTLocationTask.h"
#import "BTHasLocation.h"
#import "BTDisplayObject.h"

@implementation BTLocationTask {
    float _startX;
    float _startY;
    float _deltaX;
    float _deltaY;
    __weak id<BTHasLocation> _target;
}

- (id)initWithTime:(float)seconds toX:(float)x toY:(float)y {
    return [self initWithTime:seconds toX:x toY:x interpolator:BTLinearInterpolator target:nil];
}

- (id)initWithTime:(float)seconds toX:(float)x toY:(float)y interpolator:(BTInterpolator)interp {
    return [self initWithTime:seconds toX:x toY:y interpolator:interp target:nil];
}

- (id)initWithTime:(float)seconds toX:(float)x toY:(float)y target:(id<BTHasLocation>)target {
    return [self initWithTime:seconds toX:x toY:y interpolator:BTLinearInterpolator target:target];
}

- (id)initWithTime:(float)seconds toX:(float)x toY:(float)y interpolator:(BTInterpolator)interp 
           target:(id<BTHasLocation>)target {
    if (!(self = [super initWithTime:seconds interpolator:interp])) return nil;
    _target = target;
    
    __weak BTLocationTask *this = self;
    [self.attached connectUnit:^{
        if (_target == nil) {
            _target = ((BTDisplayObject *)this.parent).display;
        }
        _startX = _target.x;
        _startY = _target.y;
        _deltaX = x - _startX;
        _deltaY = y - _startY;
    }];
    
    return self;
}

- (void)updateInterpolatedTo:(float)interpolated {
    _target.x = _startX + _deltaX * interpolated;
    _target.y = _startY + _deltaY * interpolated;
}
@end
