//
// Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTNode.h"

@interface BTDetachTask : BTNode
+(BTDetachTask*)detachParent;
+(BTDetachTask*)detachNode:(BTNode*)node;
@end
