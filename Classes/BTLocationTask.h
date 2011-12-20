//
// Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>

#import "BTInterpolationTask.h"

@interface BTLocationTask : BTInterpolationTask
- (id)initOverTime:(double)seconds toX:(float)x toY:(float)y;
- (id)initOverTime:(double)seconds toX:(float)x toY:(float)y withInterpolator:(BTInterpolator)interp;
- (id)initOverTime:(double)seconds toX:(float)x toY:(float)y onDisplay:(SPDisplayObject*)display;
- (id)initOverTime:(double)seconds toX:(float)x toY:(float)y withInterpolator:(BTInterpolator)interp onDisplay:(SPDisplayObject*)display;
@end
