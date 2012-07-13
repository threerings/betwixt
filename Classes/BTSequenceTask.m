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
        [self.conns onReactor:node.removed connectUnit:^{
            if (++_position >= [_nodes count]) {
                [self removeSelf];
            } else if (self.parent.isLive) {
                [self.parent addNode:[_nodes objectAtIndex:_position]];
            }
        }];
    }

    // Kick off the first task
    [self.parent addNode:[_nodes objectAtIndex:0]];
}

+ (BTSequenceTask*)withNodes:(BTNode*)node, ... {
    return [[BTSequenceTask alloc] initWithNodes:OOO_VARARGS_TO_ARRAY(BTNode*, node)];
}
@end
