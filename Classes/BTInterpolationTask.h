//
// Betwixt - Copyright 2012 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTInterpolator.h"
#import "BTNode.h"
#import "BTWaitTask.h"

@interface BTInterpolationTask : BTDurationTask {
@protected
    BTInterpolator _interpolator;
    SPDisplayObject *_target;
}

- (id)initWithTime:(float)seconds interpolator:(BTInterpolator)interp 
           display:(SPDisplayObject*)display;
@end
