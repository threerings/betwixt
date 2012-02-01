//
// Betwixt - Copyright 2012 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTNode.h"

@interface BTParallelTask : BTNode
+ (BTParallelTask*)withNodes:(BTNode*)node, ...;
@end
