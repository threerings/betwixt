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

@end

@implementation BTDelayTask (protected)
- (id)initOverTime:(double)seconds {
    if (!(self = [super init])) return nil;
    _totalTime = seconds;
    [self.attached connectUnit:^{
       [self.conns addConnection:[self.root.enterFrame connectSlot:^(double timePassed){
            _elapsedTime += timePassed;
            if (_elapsedTime > _totalTime) _elapsedTime = _totalTime;
            [self updateTo:_elapsedTime outOf:_totalTime];
            if (_elapsedTime == _totalTime) [self detach];
        }]];
    }];
    return self;
}

-(void)updateTo:(double)elapsed outOf:(double)total { }
@end
