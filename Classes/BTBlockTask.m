//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTBlockTask.h"
#import "BTMode.h"
#import "BTUpdatable.h"
#import "BTNode+Protected.h"

typedef void (^BTOnceBlock)();
typedef void (^BTUpdateBlock)(BTBlockTask* task, float dt);

@interface BTDoBlockOnceTask : BTBlockTask
@property (nonatomic,copy) BTOnceBlock block;
@end
@implementation BTDoBlockOnceTask
@synthesize block;
- (void)added {
    [super added];
    self.block();
    [self removeSelf];
}

@end

@interface BTUpdateBlockTask : BTBlockTask <BTUpdatable>
@property (nonatomic,copy) BTUpdateBlock block;
@end
@implementation BTUpdateBlockTask
@synthesize block;
- (void)update:(float)dt {
    self.block(self, dt);
}
@end

@implementation BTBlockTask

+ (BTBlockTask*)once:(BTOnceBlock)block {
    BTDoBlockOnceTask* task = [[BTDoBlockOnceTask alloc] init];
    task.block = block;
    return task;
}

+ (BTBlockTask*)onUpdate:(BTUpdateBlock)block {
    BTUpdateBlockTask* task = [[BTUpdateBlockTask alloc] init];
    task.block = block;
    return task;
}
@end
