//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObjectTask.h"
#import "BTDisplayObject.h"

@implementation BTDisplayObjectTask

- (id)initWithTime:(float)seconds interpolator:(BTInterpolator *)interp 
           target:(SPDisplayObject *)target {
    if (!(self = [super initWithTime:seconds interpolator:interp])) return nil;
    _target = target;
    if (!_target) {
        [_conns addConnection:[self.attached connectUnit:^{
            _target = ((BTDisplayObject *)self.parent).display;
        }]];
    }
    return self;
}

@end
