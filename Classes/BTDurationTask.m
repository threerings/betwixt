//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDurationTask.h"
#import "BTDurationTask+Protected.h"

@implementation BTDurationTask

- (id)initWithTime:(float)time {
    if (!(self = [super init])) {
        return nil;
    }
    
    _totalTime = time;
    return self;
}

- (void)update:(float)dt {
    _elapsedTime = MIN(_elapsedTime + dt, _totalTime);
    [self updateTo:_elapsedTime outOf:_totalTime];
    if (_elapsedTime == _totalTime) {
        [self detach];
    }
}

- (void)updateTo:(float)elapsed outOf:(float)total {}

@end
