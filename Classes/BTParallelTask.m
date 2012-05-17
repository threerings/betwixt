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

- (void)attached {
    [super attached];
    
    __block int toDetach = [_nodes count];
    for (BTNode* node in _nodes) {
        [self.parent addNode:node]; 
        [node.detached connectUnit:^{ if (--toDetach == 0) [self detach]; }];
    }
}

+ (BTParallelTask*)withNodes:(BTNode*)node, ... {
    va_list ap;
    va_start(ap, node);
    NSMutableArray* nodes = [[NSMutableArray alloc] init];
    for (; node != nil; node = va_arg(ap, BTNode*)) [nodes addObject:node];
    va_end(ap);
    return [[BTParallelTask alloc] initWithNodes:nodes];
}
@end
