//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTClipRectTask.h"
#import "BTInterpolationTask+Protected.h"

@implementation BTClipRectTask

+ (BTClipRectTask*)withTime:(float)seconds clipRect:(SPRectangle*)clipRect {
    return [[BTClipRectTask alloc] initWithTime:seconds clipRect:clipRect interpolator:OOOEasing.linear target:nil];
}

+ (BTClipRectTask*)withTime:(float)seconds clipRect:(SPRectangle*)clipRect interpolator:(id<OOOInterpolator>)interp {
    return [[BTClipRectTask alloc] initWithTime:seconds clipRect:clipRect interpolator:interp target:nil];
}

+ (BTClipRectTask*)withTime:(float)seconds clipRect:(SPRectangle*)clipRect target:(SPDisplayObjectContainer*)target {
    return [[BTClipRectTask alloc] initWithTime:seconds clipRect:clipRect interpolator:OOOEasing.linear target:target];
}

+ (BTClipRectTask*)withTime:(float)seconds clipRect:(SPRectangle*)clipRect interpolator:(id<OOOInterpolator>)interp
                     target:(SPDisplayObjectContainer*)target {
    return [[BTClipRectTask alloc] initWithTime:seconds clipRect:clipRect interpolator:interp target:target];
}

- (id)initWithTime:(float)seconds clipRect:(SPRectangle*)clipRect interpolator:(id<OOOInterpolator>)interp target:(SPDisplayObjectContainer*)target {
    if ((self = [super initWithTime:seconds interpolator:interp target:target])) {
        _curClip = [[SPRectangle alloc] init];
        _endClip = [clipRect copy];
    }
    return self;
}

- (void)added {
    [super added];
    if (![_target isKindOfClass:[SPDisplayObjectContainer class]]) {
        [NSException raise:NSGenericException format:@"%@: target must be a %@",
            NSStringFromClass([self class]), NSStringFromClass([SPDisplayObjectContainer class])];
    }
    _containerTarget = (SPDisplayObjectContainer*)_target;
    _startClip = [_containerTarget.clipRect copy];
    if (_startClip == nil) {
        _startClip = _containerTarget.bounds;
    }
}

- (void)updateValues {
    _curClip.x = [self interpolate:_startClip.x to:_endClip.x];
    _curClip.y = [self interpolate:_startClip.y to:_endClip.y];
    _curClip.width = [self interpolate:_startClip.width to:_endClip.width];
    _curClip.height = [self interpolate:_startClip.height to:_endClip.width];
    _containerTarget.clipRect = _curClip;
}

@end
