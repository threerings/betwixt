//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObjectTask.h"
#import "BTViewObject.h"
#import "BTNode+Protected.h"

@implementation BTDisplayObjectTask

- (id)initWithTime:(float)seconds interpolator:(id<OOOInterpolator>)interp 
           target:(SPDisplayObject*)target {
    if (!(self = [super initWithTime:seconds interpolator:interp])) return nil;
    _target = target;
    return self;
}

- (void)added {
    [super added];
    if (!_target) {
        _target = ((BTViewObject*)self.parent).display;
    }
}

@end
