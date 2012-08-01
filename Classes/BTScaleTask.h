//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObjectTask.h"

@interface BTScaleTask : BTDisplayObjectTask {
@protected
    float _startX;
    float _startY;
    float _endX;
    float _endY;
}

+ (BTScaleTask*)withTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY;
+ (BTScaleTask*)withTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY
      interpolator:(id<OOOInterpolator>)interp;
+ (BTScaleTask*)withTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY
            target:(SPDisplayObject*)target;
+ (BTScaleTask*)withTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY
      interpolator:(id<OOOInterpolator>)interp target:(SPDisplayObject*)target;

- (id)initWithTime:(float)seconds scaleX:(float)scaleX scaleY:(float)scaleY
      interpolator:(id<OOOInterpolator>)interp target:(SPDisplayObject*)target;

@end
