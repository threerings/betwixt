//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObjectTask.h"

@interface BTAlphaTask : BTDisplayObjectTask
- (id)initWithTime:(float)seconds alpha:(float)alpha;
- (id)initWithTime:(float)seconds alpha:(float)alpha interpolator:(BTInterpolator)interp;
- (id)initWithTime:(float)seconds alpha:(float)alpha display:(SPDisplayObject*)display;
- (id)initWithTime:(float)seconds alpha:(float)alpha interpolator:(BTInterpolator)interp 
           display:(SPDisplayObject*)display;
@end
