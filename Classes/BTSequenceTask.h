//
// Betwixt - Copyright 2012 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTNode.h"

@interface BTSequenceTask : BTNode
+ (BTSequenceTask*)withNodes:(BTNode*)node, ...;
@end
