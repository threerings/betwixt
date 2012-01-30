//
// Betwixt - Copyright 2012 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTInterpolationTask.h"

@interface BTRotationTask : BTInterpolationTask
- (id)initOverTime:(float)seconds toRotation:(float)rads;

- (id)initOverTime:(float)seconds toRotation:(float)rads withInterpolator:(BTInterpolator)interp;

- (id)initOverTime:(float)seconds toRotation:(float)rads onDisplay:(SPDisplayObject*)display;

- (id)initOverTime:(float)seconds toRotation:(float)rads
  withInterpolator:(BTInterpolator)interp onDisplay:(SPDisplayObject*)display;
@end
