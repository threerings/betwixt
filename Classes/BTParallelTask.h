//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTNode.h"

@interface BTParallelTask : BTNode {
@protected
    NSArray *_nodes;
}
+ (BTParallelTask*)withNodes:(BTNode*)node, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithNodes:(NSArray*)nodes;
@end
