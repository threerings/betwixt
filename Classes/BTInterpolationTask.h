//
// Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTInterpolator.h"
#import "BTNode.h"
#import "BTDelayTask.h"

@interface BTInterpolationTask : BTDelayTask {
    @protected
        SPDisplayObject *_target;
}
-(id)initOverTime:(double)seconds withInterpolator:(BTInterpolator)interp onDisplay:(SPDisplayObject*)display;
@end
