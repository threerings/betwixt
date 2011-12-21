//
// Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTNode.h"

@interface BTTaskSequence : BTNode
+ (BTTaskSequence*)seqWithNodes:(BTNode*)node, ...;
@end
