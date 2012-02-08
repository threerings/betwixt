//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObjectTask.h"

@interface BTAlphaTask : BTDisplayObjectTask
- (id)initWithTime:(float)seconds alpha:(float)alpha;
- (id)initWithTime:(float)seconds alpha:(float)alpha interpolator:(BTInterpolator)interp;
- (id)initWithTime:(float)seconds alpha:(float)alpha target:(SPDisplayObject*)target;
- (id)initWithTime:(float)seconds alpha:(float)alpha interpolator:(BTInterpolator)interp 
           target:(SPDisplayObject*)target;
@end
