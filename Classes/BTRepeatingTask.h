//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTNode.h"

@class BTRepeatingTask;

typedef BTNode* (^BTRepeatCreator)(void);

@interface BTRepeatingTask : BTNode
+ (BTRepeatingTask*)withTaskCreator:(BTRepeatCreator)creator;
@end
