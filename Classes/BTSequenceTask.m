//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTSequenceTask.h"
#import "BTNodeContainer.h"
#import "BTNode+Protected.h"

@implementation BTSequenceTask

- (id)initWithNodes:(NSArray*)nodes {
    if ((self = [super init])) {
        _nodes = nodes;
    }
    return self;
}

- (void)added {
    [super added];

    [self.conns onReactor:self.removed connectUnit:^{
        if (_position == [_nodes count]) return;
        BTNode* toRemove = [_nodes objectAtIndex:_position];
        _position = [_nodes count];
        [toRemove removeSelf];
    }];

    for (BTNode* node in _nodes) {
        [node.removed connectUnit:^{
            if (++_position >= [_nodes count]) [self removeSelf];
            else [self.parent addNode:[_nodes objectAtIndex:_position]];
        }];
    }

    // Kick off the first task
    [self.parent addNode:[_nodes objectAtIndex:0]];
}

+ (BTSequenceTask*)withNodes:(BTNode*)node, ... {
    va_list ap;
    va_start(ap, node);
    NSMutableArray* nodes = [[NSMutableArray alloc] init];
    for (; node != nil; node = va_arg(ap, BTNode*)) {
        [nodes addObject:node];
    }
    va_end(ap);
    return [[BTSequenceTask alloc] initWithNodes:nodes];
}
@end
