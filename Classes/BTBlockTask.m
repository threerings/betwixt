//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTBlockTask.h"
#import "BTMode.h"
#import "BTUpdatable.h"
#import "BTNode+Protected.h"

@interface BTBlockTask () {
@public
    BTTaskBlock _block;
}
@end

@interface BTAttachBlockTask : BTBlockTask
@end
@implementation BTAttachBlockTask
- (void)attached {
    [super attached];
    _block(self);
    [self detach];
}

@end

@interface BTUpdateBlockTask : BTBlockTask <BTUpdatable>
@end
@implementation BTUpdateBlockTask
- (void)update:(float)dt {
    _block(self);
}
@end

@implementation BTBlockTask

+ (BTBlockTask*)onAttach:(BTTaskBlock)block {
    BTBlockTask* task = [[BTAttachBlockTask alloc] init];
    task->_block = block;
    return task;
}

+ (BTBlockTask*)onUpdate:(BTTaskBlock)block {
    BTBlockTask* task = [[BTUpdateBlockTask alloc] init];
    task->_block = block;
    return task;
}
@end
