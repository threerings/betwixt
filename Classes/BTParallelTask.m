//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTParallelTask.h"
#import "BTNodeContainer.h"
#import "BTNode+Protected.h"

@implementation BTParallelTask

- (id)initWithNodes:(NSArray*)nodes {
    if ((self = [super init])) {
        _nodes = nodes;
    }
    return self;
}

- (void)added {
    [super added];

    __block int toRemove = [_nodes count];
    for (BTNode* node in _nodes) {
        [self.parent addNode:node];
        [node.removed connectUnit:^{ if (--toRemove == 0) [self removeSelf]; }];
    }
}

+ (BTParallelTask*)withNodes:(NSArray*)nodes {
    return [[BTParallelTask alloc] initWithNodes:nodes];
}
@end
