//
// Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTNode.h"

@class BTBlockTask;

typedef void (^BTTaskBlock)(BTBlockTask *task);

@interface BTBlockTask : BTNode
+ (BTBlockTask*)withBlock:(BTTaskBlock)block;
@end
