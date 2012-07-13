//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDurationTask.h"

@interface BTWaitTask : BTDurationTask
+ (BTWaitTask*)withTime:(float)seconds;
@end
