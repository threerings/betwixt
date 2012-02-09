//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTParallelTask.h"
#import "BTNodeContainer.h"

@implementation BTParallelTask

- (id)initWithNodes:(NSArray*)nodes {
    if (!(self = [super init])) return nil;
    __block int toDetach = [nodes count];
    for (BTNode* node in nodes) {
        [node.detached connectUnit:^{ if (--toDetach == 0) [self detach]; }];
    }
    [self.attached connectUnit:^{ for (BTNode* node in nodes) [self.parent addNode:node]; }];
    return self;
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
