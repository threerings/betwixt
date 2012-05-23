//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTRemoveTask.h"
#import "BTNodeContainer.h"
#import "BTNode+Protected.h"

@implementation BTRemoveTask

+ (BTRemoveTask*)removeNode {
    return [[BTRemoveTask alloc] init];
}

- (void)added {
    [super added];
    [((BTNode*) self.parent) removeSelf];
}

@end
