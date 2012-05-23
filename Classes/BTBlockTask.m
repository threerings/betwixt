//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTBlockTask.h"
#import "BTMode.h"
#import "BTUpdatable.h"
#import "BTNode+Protected.h"

@interface BTBlockTask ()
@property(nonatomic,copy) BTTaskBlock block;
@end

@interface BTDoBlockOnceTask : BTBlockTask
@end
@implementation BTDoBlockOnceTask
- (void)added {
    [super added];
    self.block(self);
    [self removeSelf];
}

@end

@interface BTUpdateBlockTask : BTBlockTask <BTUpdatable>
@end
@implementation BTUpdateBlockTask
- (void)update:(float)dt {
    self.block(self);
}
@end

@implementation BTBlockTask

@synthesize block;

+ (BTBlockTask*)once:(BTTaskBlock)block {
    BTBlockTask* task = [[BTDoBlockOnceTask alloc] init];
    task.block = block;
    return task;
}

+ (BTBlockTask*)onUpdate:(BTTaskBlock)block {
    BTBlockTask* task = [[BTUpdateBlockTask alloc] init];
    task.block = block;
    return task;
}
@end
