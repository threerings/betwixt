//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTRepeatingTask.h"
#import "BTNodeContainer.h"
#import "BTNode+Protected.h"

@implementation BTRepeatingTask {
    BTRepeatCreator _creator;
}

- (void)onRepeat {
    BTNode* toRepeat = _creator();
    if (toRepeat == nil) [self detach];
    else {
        [toRepeat.detached connectUnit:^{ [self onRepeat]; }];
        [self.parent addNode:toRepeat];
    }
}

- (void)attached {
    [super attached];
    [self onRepeat];
}

+ (BTRepeatingTask*)withTaskCreator:(BTRepeatCreator)creator {
    BTRepeatingTask* task = [[BTRepeatingTask alloc] init];
    task->_creator = creator;
    return task;
}

@end
