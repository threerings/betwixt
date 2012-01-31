//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObjectTask.h"

@interface BTLocationTask : BTDisplayObjectTask
- (id)initWithTime:(float)seconds toX:(float)x toY:(float)y;
- (id)initWithTime:(float)seconds toX:(float)x toY:(float)y interpolator:(BTInterpolator)interp;
- (id)initWithTime:(float)seconds toX:(float)x toY:(float)y display:(SPDisplayObject*)display;
- (id)initWithTime:(float)seconds toX:(float)x toY:(float)y interpolator:(BTInterpolator)interp display:(SPDisplayObject*)display;
@end
