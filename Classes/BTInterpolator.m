//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTInterpolator.h"

@interface BTLinearInterpolator : BTInterpolator
@end

@implementation BTLinearInterpolator
- (float)interpolate:(float)from to:(float)to dt:(float)dt t:(float)t {
    if (t == 0) { 
        return to;
    }
    return from + ((to - from) * (dt / t));
}
@end

@interface BTEaseInInterpolator : BTInterpolator
@end

@implementation BTEaseInInterpolator
- (float)interpolate:(float)from to:(float)to dt:(float)dt t:(float)t {
    if (t == 0) { 
        return to;
    }
    float dtt = dt / t;
    return from + ((to - from) * dtt * dtt * dtt);
}
@end

@interface BTEaseOutInterpolator : BTInterpolator
@end

@implementation BTEaseOutInterpolator
- (float)interpolate:(float)from to:(float)to dt:(float)dt t:(float)t {
    if (t == 0) { 
        return to;
    }
    float dtt = dt / t - 1;
    return from + ((to - from) * (1 + dtt * dtt * dtt));
}
@end

@interface BTEaseInOutInterpolator : BTInterpolator
@end

@implementation BTEaseInOutInterpolator
- (float)interpolate:(float)from to:(float)to dt:(float)dt t:(float)t {
    if (t == 0) { 
        return to;
    }
    float range = to - from;
    float hdtt = dt / (t/2);
    if (hdtt < 1) {
        return from + range/2 * hdtt * hdtt * hdtt;
    } else {
        float nhdtt = hdtt - 2;
        return from + range/2 * (2 + nhdtt * nhdtt * nhdtt);
    }
}
@end

@implementation BTInterpolator
- (float)interpolate:(float)from to:(float)to dt:(float)dt t:(float)t { return to; }

+ (BTInterpolator*)LINEAR {
    static BTInterpolator* interp = nil;
    @synchronized(self) {
        if (interp == nil) {
            interp = [[BTLinearInterpolator alloc] init];
        }
    }
    return interp;
}

+ (BTInterpolator*)EASE_IN {
    static BTInterpolator* interp = nil;
    @synchronized(self) {
        if (interp == nil) {
            interp = [[BTEaseInInterpolator alloc] init];
        }
    }
    return interp;
}

+ (BTInterpolator*)EASE_OUT {
    static BTInterpolator* interp = nil;
    @synchronized(self) {
        if (interp == nil) {
            interp = [[BTEaseOutInterpolator alloc] init];
        }
    }
    return interp;
}

+ (BTInterpolator*)EASE_IN_OUT {
    static BTInterpolator* interp = nil;
    @synchronized(self) {
        if (interp == nil) {
            interp = [[BTEaseInOutInterpolator alloc] init];
        }
    }
    return nil;
}
@end