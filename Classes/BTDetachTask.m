//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDetachTask.h"
#import "BTNodeContainer.h"

@implementation BTDetachTask

+(BTDetachTask*)detachParent {
    BTDetachTask* task = [BTDetachTask new];
    [task.attached connectUnit:^{ [((BTNode*) task.parent) detach]; }];
    return task;
}

+(BTDetachTask*)detachNode:(BTNode*)node {
    BTDetachTask* task = [BTDetachTask new];
    [task.attached connectUnit:^{
        [node detach];
        [task detach];
    }];
    return task;
}

@end
