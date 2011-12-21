//
// Betwixt - Copyright 2011 Three Rings Design

#import "BTDestroyParentTask.h"
#import "BTContext.h"

@implementation BTDestroyParentTask
- (id)init {
    if (!(self = [super init])) return nil;
    [self.attached connectUnit:^{ [self.parent detach]; }];
    return self;
}
@end
