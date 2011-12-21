//
// Betwixt - Copyright 2011 Three Rings Design

#import "BTTaskSequence.h"
#import "BTContext.h"

@implementation BTTaskSequence {
    NSArray *_nodes;
    int _position;
}
- (id)initWithNodes:(NSArray*)nodes {
    if (!(self = [super init])) return nil;
    _nodes = nodes;
    [self.detached connectUnit:^{
        if (_position == [_nodes count]) return;
        BTNode *toDetach = [_nodes objectAtIndex:_position];
        _position = [_nodes count];
        [toDetach detach];
    }];
    [self.attached connectUnit:^{ [self.parent addNode:[nodes objectAtIndex:0]]; }];
    for (BTNode *node in _nodes) {
        [node.detached connectUnit:^{
            if (++_position == [_nodes count]) {
                [self detach];
            } else {
                [self.parent addNode:[_nodes objectAtIndex:_position]];
            }
        }];
    }
    return self;
}

+ (BTTaskSequence*)seqWithNodes:(BTNode*)node, ... {
    va_list ap;
    va_start(ap, node);
    NSMutableArray *nodes = [[NSMutableArray alloc] init];
    for (; node != nil; node = va_arg(ap, BTNode*)) {
        [nodes addObject:node];
    }
    va_end(ap);
    return [[BTTaskSequence alloc] initWithNodes:nodes];
}
@end
