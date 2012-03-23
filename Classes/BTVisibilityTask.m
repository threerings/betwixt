//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTVisibilityTask.h"
#import "BTDisplayObject.h"
#import "BTNode+Protected.h"

@implementation BTVisibilityTask {
    BOOL _visible;
    __weak SPDisplayObject* _target;
}

+ (BTVisibilityTask*)setVisible:(BOOL)visible {
    return [[BTVisibilityTask alloc] initWithVisible:visible target:nil];
}

+ (BTVisibilityTask*)setVisible:(BOOL)visible target:(SPDisplayObject*)target {
    return [[BTVisibilityTask alloc] initWithVisible:visible target:target];
}

- (id)initWithVisible:(BOOL)visible target:(SPDisplayObject*)target {
    if (!(self = [super init])) {
        return nil;
    }
    _target = target;
    _visible = visible;
    return self;
}

- (void)attached {
    [super attached];
    if (!_target) {
        _target = ((BTDisplayObject*)self.parent).display;
    }
}

- (void)update:(float)dt {
    _target.visible = _visible;
    [self detach];
}

@end
