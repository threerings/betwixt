//
// Betwixt - Copyright 2012 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTInterpolator.h"
#import "BTNode.h"
#import "BTDelayTask.h"

@interface BTInterpolationTask : BTDelayTask {
    @protected
        SPDisplayObject *_target;
}
-(id)initOverTime:(float)seconds withInterpolator:(BTInterpolator)interp onDisplay:(SPDisplayObject*)display;
@end
