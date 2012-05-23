//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTLocationTask.h"
#import "BTNode+Protected.h"
#import "BTInterpolationTask+Protected.h"
#import "BTHasLocation.h"
#import "BTDisplayObject.h"

@implementation BTLocationTask

+ (BTLocationTask*)withTime:(float)seconds toX:(float)x toY:(float)y {
    return [[BTLocationTask alloc] initWithTime:seconds toX:x toY:y];
}

+ (BTLocationTask*)withTime:(float)seconds toX:(float)x toY:(float)y interpolator:(id<OOOInterpolator>)interp {
    return [[BTLocationTask alloc] initWithTime:seconds toX:x toY:y interpolator:interp];
}

+ (BTLocationTask*)withTime:(float)seconds toX:(float)x toY:(float)y target:(id<BTHasLocation>)target {
    return [[BTLocationTask alloc] initWithTime:seconds toX:x toY:y target:target];
}

+ (BTLocationTask*)withTime:(float)seconds toX:(float)x toY:(float)y interpolator:(id<OOOInterpolator>)interp target:(id<BTHasLocation>)target {
    return [[BTLocationTask alloc] initWithTime:seconds toX:x toY:y interpolator:interp target:target];
}

- (id)initWithTime:(float)seconds toX:(float)x toY:(float)y {
    return [self initWithTime:seconds toX:x toY:y interpolator:OOOEasing.linear target:nil];
}

- (id)initWithTime:(float)seconds toX:(float)x toY:(float)y interpolator:(id<OOOInterpolator>)interp {
    return [self initWithTime:seconds toX:x toY:y interpolator:interp target:nil];
}

- (id)initWithTime:(float)seconds toX:(float)x toY:(float)y target:(id<BTHasLocation>)target {
    return [self initWithTime:seconds toX:x toY:y interpolator:OOOEasing.linear target:target];
}

- (id)initWithTime:(float)seconds toX:(float)x toY:(float)y interpolator:(id<OOOInterpolator>)interp 
           target:(id<BTHasLocation>)target {
    if (!(self = [super initWithTime:seconds interpolator:interp])) return nil;
    
    _target = target;
    _endX = x;
    _endY = y;
    
    return self;
}

- (void)added {
    [super added];
    if (_target == nil) {
        _target = ((BTDisplayObject*)self.parent).display;
    }
    _startX = _target.x;
    _startY = _target.y;
}

- (void)updateValues {
    _target.x = [self interpolate:_startX to:_endX];
    _target.y = [self interpolate:_startY to:_endY];
}

@end
