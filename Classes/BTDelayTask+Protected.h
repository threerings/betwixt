//
// Betwixt - Copyright 2011 Three Rings Design

#import "BTDelayTask.h"

@interface BTDelayTask (protected)
-(id)initOverTime:(float)seconds;
-(void)updateTo:(float)elapsed outOf:(float)total;
@end
