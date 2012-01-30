//
// Betwixt - Copyright 2012 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTNode.h"

@class BTBlockTask;

typedef void (^BTTaskBlock)(BTBlockTask *task);

@interface BTBlockTask : BTNode
+ (BTBlockTask*)onAttach:(BTTaskBlock)block;
+ (BTBlockTask*)onUpdate:(BTTaskBlock)block;
@end
