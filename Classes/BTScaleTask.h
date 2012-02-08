//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObjectTask.h"

@interface BTScaleTask : BTDisplayObjectTask

- (id)initWithTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY;
- (id)initWithTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY 
      interpolator:(BTInterpolator)interp;
- (id)initWithTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY 
            target:(SPDisplayObject *)target;
- (id)initWithTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY 
      interpolator:(BTInterpolator)interp target:(SPDisplayObject *)target;

@end
