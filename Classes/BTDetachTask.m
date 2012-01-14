//
// Betwixt - Copyright 2011 Three Rings Design

#import "BTDetachTask.h"
#import "BTNodeContainer.h"

@implementation BTDetachTask

+(BTDetachTask*)detachParent {
    BTDetachTask* task = [BTDetachTask new];
    [task.attached connectUnit:^{ [task.parent detach]; }];
    return task;
}

+(BTDetachTask*)detachNode:(BTNode*)node {
    BTDetachTask* task = [BTDetachTask new];
    [task.attached connectUnit:^{ [node detach]; }];
    return task;
}

@end
