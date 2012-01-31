//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTNode.h"
#import "BTUpdatable.h"

@interface BTDurationTask : BTNode<BTUpdatable> {
@protected
    float _totalTime;
    float _elapsedTime;
}

- (id)initWithTime:(float)time;
- (void)update:(float)dt;

@end
