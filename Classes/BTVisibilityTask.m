//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTVisibilityTask.h"
#import "BTViewObject.h"
#import "BTNode+Protected.h"

@implementation BTVisibilityTask

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

- (void)added {
    [super added];
    if (!_target) {
        _target = ((BTViewObject*)self.parent).display;
    }
}

- (void)update:(float)dt {
    _target.visible = _visible;
    [self removeSelf];
}

@end
