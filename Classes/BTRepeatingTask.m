//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTRepeatingTask.h"

#import "BTNodeContainer.h"

@implementation BTRepeatingTask {
    BTRepeatCreator _creator;
}

- (void)onRepeat {
    BTNode *toRepeat = _creator();
    if (toRepeat == nil) [self detach];
    else {
        [toRepeat.detached connectUnit:^{ [self onRepeat]; }];
        [self.parent addNode:toRepeat];
    }
}

+ (BTRepeatingTask*)withTaskCreator:(BTRepeatCreator)creator {
    BTRepeatingTask *task = [[BTRepeatingTask alloc] init];
    task->_creator = creator;
    [task.attached connectUnit:^{ [task onRepeat]; }];
    return task;
}

@end
