//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTInterpolationTask+Protected.h"

@implementation BTInterpolationTask

- (id)initWithTime:(float)seconds interpolator:(BTInterpolator)interp {
    if (!(self = [super initWithTime:seconds])) return nil;
    _interpolator = interp;
    return self;
}

- (void)updateTo:(float)elapsed outOf:(float)total {
    [self updateInterpolatedTo:_interpolator(elapsed/total)];
}

- (void)updateInterpolatedTo:(float)interpolated {}

@end
