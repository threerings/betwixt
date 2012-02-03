//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObjectTask.h"
#import "BTDisplayObject.h"

@implementation BTDisplayObjectTask

- (id)initWithTime:(float)seconds interpolator:(BTInterpolator)interp 
           display:(SPDisplayObject *)display {
    if (!(self = [super initWithTime:seconds interpolator:interp])) return nil;
    _target = display;
    if (!_target) {
        __weak BTDisplayObjectTask *this = self;
        [self.attached connectUnit:^{
            _target = ((BTDisplayObject *)this.parent).display;
        }];
    }
    return self;
}

@end
