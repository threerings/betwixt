//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObjectTask.h"

@protocol BTHasLocation;

@interface BTLocationTask : BTInterpolationTask
+ (BTLocationTask *)withTime:(float)seconds toX:(float)x toY:(float)y;
+ (BTLocationTask *)withTime:(float)seconds toX:(float)x toY:(float)y interpolator:(BTInterpolator *)interp;
+ (BTLocationTask *)withTime:(float)seconds toX:(float)x toY:(float)y target:(id<BTHasLocation>)target;
+ (BTLocationTask *)withTime:(float)seconds toX:(float)x toY:(float)y interpolator:(BTInterpolator *)interp target:(id<BTHasLocation>)target;

- (id)initWithTime:(float)seconds toX:(float)x toY:(float)y;
- (id)initWithTime:(float)seconds toX:(float)x toY:(float)y interpolator:(BTInterpolator *)interp;
- (id)initWithTime:(float)seconds toX:(float)x toY:(float)y target:(id<BTHasLocation>)target;
- (id)initWithTime:(float)seconds toX:(float)x toY:(float)y interpolator:(BTInterpolator *)interp target:(id<BTHasLocation>)target;
@end
