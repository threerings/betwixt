//
// Betwixt - Copyright 2011 Three Rings Design

#import "BTDelayTask.h"

@interface BTDelayTask (protected)
-(id)initOverTime:(double)seconds;
-(void)updateTo:(double)elapsed outOf:(double)total;
@end
