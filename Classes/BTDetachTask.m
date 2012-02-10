//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDetachTask.h"
#import "BTNodeContainer.h"
#import "BTNode+Protected.h"

@interface BTDetachParentTask : BTDetachTask
@end
@implementation BTDetachParentTask
- (void)attached {
    [super attached];
    [((BTNode*) self.parent) detach];
}
@end

@interface BTDetachNodeTask : BTDetachTask {
@public
    BTNode* _node;
}
@end
@implementation BTDetachNodeTask
- (void)attached {
    [super attached];
    [_node detach];
    [self detach];
}
@end


@implementation BTDetachTask

+(BTDetachTask*)detachParent {
    return [[BTDetachParentTask alloc] init];
}

+(BTDetachTask*)detachNode:(BTNode*)node {
    BTDetachNodeTask* task = [[BTDetachNodeTask alloc] init];
    task->_node = node;
    return task;
}

@end
