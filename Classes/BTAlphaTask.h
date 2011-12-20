//
// Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTInterpolationTask.h"

@interface BTAlphaTask : BTInterpolationTask
- (id)initOverTime:(double)seconds toAlpha:(float)alpha;
- (id)initOverTime:(double)seconds toAlpha:(float)alpha withInterpolator:(BTInterpolator)interp;
- (id)initOverTime:(double)seconds toAlpha:(float)alpha onDisplay:(SPDisplayObject*)display;
- (id)initOverTime:(double)seconds toAlpha:(float)alpha
  withInterpolator:(BTInterpolator)interp onDisplay:(SPDisplayObject*)display;
@end
