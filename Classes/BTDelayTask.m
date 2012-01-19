//
// Betwixt - Copyright 2011 Three Rings Design

#import "BTDelayTask+Protected.h"

#import "BTMode.h"

@implementation BTDelayTask {
    double _elapsedTime;
    double _totalTime;
}

+ (BTDelayTask*)delayFor:(double)seconds {
    return [[BTDelayTask alloc] initOverTime:seconds];
}

- (void)update:(float)dt {
    _elapsedTime += dt;
    if (_elapsedTime > _totalTime) _elapsedTime = _totalTime;
    [self updateTo:_elapsedTime outOf:_totalTime];
    if (_elapsedTime == _totalTime) [self detach];
}

@end

@implementation BTDelayTask (protected)
- (id)initOverTime:(double)seconds {
    if (!(self = [super init])) return nil;
    _totalTime = seconds;
    return self;
}

-(void)updateTo:(double)elapsed outOf:(double)total { }
@end
