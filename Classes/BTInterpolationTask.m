//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTInterpolationTask+Protected.h"
#import "BTDisplayable.h"

@implementation BTInterpolationTask

- (id)initWithTime:(float)seconds interpolator:(BTInterpolator)interp 
           display:(SPDisplayObject *)display {
    if (!(self = [super initWithTime:seconds])) return nil;
    _target = display;
    _interpolator = interp;
    if (!_target) {
        [self.attached connectUnit:^{
            _target = ((id<BTDisplayable>)self.parent).display;
        }];
    }
    return self;
}

- (void)updateTo:(float)elapsed outOf:(float)total {
    [self updateInterpolatedTo:_interpolator(elapsed/total)];
}

- (void)updateInterpolatedTo:(float)interpolated {}

@end
