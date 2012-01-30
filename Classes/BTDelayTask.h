//
// Betwixt - Copyright 2012 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTNode.h"
#import "BTUpdatable.h"

@interface BTDelayTask : BTNode<BTUpdatable>
+ delayFor:(float)seconds;
@end
