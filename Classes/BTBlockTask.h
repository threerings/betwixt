//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTNode.h"

@interface BTBlockTask : BTNode
+ (BTBlockTask*)once:(void(^)())block;
+ (BTBlockTask*)onUpdate:(void(^)(BTBlockTask* task, float dt))block;
@end
