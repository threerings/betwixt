//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObjectTask.h"

@interface BTClipRectTask : BTDisplayObjectTask {
@protected
    SPRectangle* _startClip;
    SPRectangle* _endClip;
    SPRectangle* _curClip;
    SPDisplayObjectContainer* _containerTarget;
}

+ (BTClipRectTask*)withTime:(float)seconds clipRect:(SPRectangle*)clipRect;
+ (BTClipRectTask*)withTime:(float)seconds clipRect:(SPRectangle*)clipRect interpolator:(id<OOOInterpolator>)interp;
+ (BTClipRectTask*)withTime:(float)seconds clipRect:(SPRectangle*)clipRect target:(SPDisplayObject*)target;
+ (BTClipRectTask*)withTime:(float)seconds clipRect:(SPRectangle*)clipRect interpolator:(id<OOOInterpolator>)interp
                     target:(SPDisplayObjectContainer*)target;

- (id)initWithTime:(float)seconds clipRect:(SPRectangle*)clipRect interpolator:(id<OOOInterpolator>)interp
            target:(SPDisplayObjectContainer*)target;
@end
