//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObjectTask.h"

@interface BTVisibilityTask : BTNode <BTUpdatable> {
    BOOL _visible;
    __weak SPDisplayObject* _target;
}

+ (BTVisibilityTask*)setVisible:(BOOL)visible;
+ (BTVisibilityTask*)setVisible:(BOOL)visible target:(SPDisplayObject*)target;

- (id)initWithVisible:(BOOL)visible target:(SPDisplayObject*)target;
@end
