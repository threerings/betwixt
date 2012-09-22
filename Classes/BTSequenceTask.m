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
        BTNode* toRemove = _nodes[_position];
        _position = [_nodes count];
        [toRemove removeSelf];
    }];

    for (BTNode* node in _nodes) {
        [self.conns onReactor:node.removed connectUnit:^{
            if (++_position >= [_nodes count]) {
                [self removeSelf];
            } else if (self.parent.isLive) {
                [self.parent addNode:_nodes[_position]];
            }
        }];
    }

    // Kick off the first task
    [self.parent addNode:_nodes[0]];
}

+ (BTSequenceTask*)withNodes:(NSArray*)nodes {
    return [[BTSequenceTask alloc] initWithNodes:nodes];
}
@end
