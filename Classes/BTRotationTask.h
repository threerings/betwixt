//
// Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTInterpolationTask.h"

@interface BTRotationTask : BTInterpolationTask
- (id)initOverTime:(double)seconds toRotation:(float)rads;

- (id)initOverTime:(double)seconds toRotation:(float)rads withInterpolator:(BTInterpolator)interp;

- (id)initOverTime:(double)seconds toRotation:(float)rads onDisplay:(SPDisplayObject*)display;

- (id)initOverTime:(double)seconds toRotation:(float)rads
  withInterpolator:(BTInterpolator)interp onDisplay:(SPDisplayObject*)display;

@end
