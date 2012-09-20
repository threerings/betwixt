//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTNode.h"

@interface BTParallelTask : BTNode {
@protected
    NSArray *_nodes;
}
+ (BTParallelTask*)withNodes:(NSArray*)nodes;
- (id)initWithNodes:(NSArray*)nodes;
@end
