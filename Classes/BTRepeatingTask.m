//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTRepeatingTask.h"
#import "BTNodeContainer.h"
#import "BTNode+Protected.h"

@interface BTRepeatingTask ()
@property(nonatomic,copy) BTRepeatCreator creator;
@end

@implementation BTRepeatingTask

@synthesize creator;

- (void)onRepeat {
    BTNode* toRepeat = self.creator();
    if (toRepeat == nil) [self removeSelf];
    else {
        [toRepeat.removed connectUnit:^{ [self onRepeat]; }];
        [self.parent addNode:toRepeat];
    }
}

- (void)added {
    [super added];
    [self onRepeat];
}

+ (BTRepeatingTask*)withTaskCreator:(BTRepeatCreator)creator {
    BTRepeatingTask* task = [[BTRepeatingTask alloc] init];
    task.creator = creator;
    return task;
}

@end
