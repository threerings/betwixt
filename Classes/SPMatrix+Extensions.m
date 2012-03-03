//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPMatrix+Extensions.h"

@implementation SPMatrix (OOOExtensions)

- (float)scaleX {
    return sqrtf(mA * mA + mB * mB);
}

- (void)setScaleX:(float)scaleX {
    float cur = self.scaleX;
    if (cur != 0) {
        float scale = scaleX / cur;
        mA *= scale;
        mB *= scale;
    } else {
        float skewY = self.skewY;
        mA = cosf(skewY) * scaleX;
        mB = sinf(skewY) * scaleX;
    }
}

- (float)scaleY {
    return sqrtf(mC * mC + mD * mD);
}

- (void)setScaleY:(float)scaleY {
    float cur = self.scaleY;
    if (cur != 0) {
        float scale = scaleY / cur;
        mC *= scale;
        mD *= scale;
    } else {
        float skewX = self.skewX;
        mC = -sinf(skewX) * scaleY;
        mD = cosf(skewX) * scaleY;
    }
}

- (float)skewX {
    return atan2f(-mC, mD);
}

- (void)setSkewX:(float)skewX {
    float scaleY = self.scaleY;
    mC = -scaleY * sinf(skewX);
    mD = scaleY * cosf(skewX);
}

- (float)skewY {
    return atan2f(mB, mA);
}

- (void)setSkewY:(float)skewY {
    float scaleX = self.scaleX;
    mA = scaleX * cosf(skewY);
    mB = scaleX * sinf(skewY);
}

- (float)rotation {
    return self.skewY;
}

- (void)setRotation:(float)rotation {
    float curRotation = self.rotation;
    float curSkewX = self.skewX;
    self.skewX = curSkewX + rotation - curRotation;
    self.skewY = rotation;
}

@end
