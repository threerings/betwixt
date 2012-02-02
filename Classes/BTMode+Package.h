//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTGrouped.h"
#import "BTKeyed.h"

@interface BTMode (package)

- (void)addKeys:(BTNode<BTKeyed>*)object;
- (void)addGroups:(BTNode<BTGrouped>*)object;
- (void)enterInternal;
- (void)exitInternal;
- (void)shutdownInternal;

@end
