//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTNode.h"

@interface BTSequenceTask : BTNode
+ (BTSequenceTask*)withNodes:(BTNode*)node, ... NS_REQUIRES_NIL_TERMINATION;
@end
