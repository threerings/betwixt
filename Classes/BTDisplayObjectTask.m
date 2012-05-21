//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObjectTask.h"
#import "BTDisplayObject.h"
#import "BTNode+Protected.h"

@implementation BTDisplayObjectTask

- (id)initWithTime:(float)seconds interpolator:(id<OOOInterpolator>)interp 
           target:(SPDisplayObject*)target {
    if (!(self = [super initWithTime:seconds interpolator:interp])) return nil;
    _target = target;
    return self;
}

- (void)attached {
    [super attached];
    if (!_target) {
        _target = ((BTDisplayObject*)self.parent).display;
    }
}

@end
