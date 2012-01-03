//
// Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTNode.h"

@class BTBlockTask;

typedef void (^BTTaskBlock)(BTBlockTask *task);

@interface BTBlockTask : BTNode
+ (BTBlockTask*)onAttach:(BTTaskBlock)block;
+ (BTBlockTask*)onEnterFrame:(BTTaskBlock)block;
@end
