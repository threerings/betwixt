//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTNode.h"

@class BTBlockTask;

typedef void (^BTTaskBlock)(BTBlockTask* task);

@interface BTBlockTask : BTNode
+ (BTBlockTask*)once:(BTTaskBlock)block;
+ (BTBlockTask*)onUpdate:(BTTaskBlock)block;
@end
