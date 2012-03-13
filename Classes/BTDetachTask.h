//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTNode.h"

@interface BTDetachTask : BTNode
+(BTDetachTask*)detachParent;
+(BTDetachTask*)detachNode:(BTNode*)node;
@end
