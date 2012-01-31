//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObjectTask.h"
#import "BTDisplayable.h"

@implementation BTDisplayObjectTask

- (id)initWithTime:(float)seconds interpolator:(BTInterpolator)interp 
           display:(SPDisplayObject *)display {
    if (!(self = [super initWithTime:seconds interpolator:interp])) return nil;
    _target = display;
    if (!_target) {
        [self.attached connectUnit:^{
            _target = ((id<BTDisplayable>)self.parent).display;
        }];
    }
    return self;
}

@end
