//
// Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTInterpolator.h"
#import "BTObject.h"

@interface BTInterpolationTask : BTObject {
    @protected
        SPDisplayObject *_target;
}
-(id)initOverTime:(double)seconds withInterpolator:(BTInterpolator)interp onDisplay:(SPDisplayObject*)display;

-(void)updateInterpolatedTo:(float)interp;
@end
