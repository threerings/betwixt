//
// Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTInterpolationTask.h"

@interface BTAlphaTask : BTInterpolationTask
- (id)initOverTime:(float)seconds toAlpha:(float)alpha;
- (id)initOverTime:(float)seconds toAlpha:(float)alpha withInterpolator:(BTInterpolator)interp;
- (id)initOverTime:(float)seconds toAlpha:(float)alpha onDisplay:(SPDisplayObject*)display;
- (id)initOverTime:(float)seconds toAlpha:(float)alpha
  withInterpolator:(BTInterpolator)interp onDisplay:(SPDisplayObject*)display;
@end
