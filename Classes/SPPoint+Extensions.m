//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPPoint+Extensions.h"
#import <math.h>

#define SQ(x) ((x)*(x))

@implementation SPPoint (OOOExtensions)

- (void)set:(SPPoint *)pt {
    mX = pt.x;
    mY = pt.y;
}

- (void)setX:(int)x y:(int)y {
    mX = x;
    mY = y;
}

- (SPPoint *)addX:(float)x y:(float)y {
    return [[SPPoint alloc] initWithX:mX+x y:mY+y];
}

- (SPPoint *)subtractX:(float)x y:(float)y {
    return [[SPPoint alloc] initWithX:mX-x y:mY-y];
}

+ (float)distanceSqFromPoint:(SPPoint *)p1 toPoint:(SPPoint *)p2 {
    return SQ(p2->mX - p1->mX) + SQ(p2->mY - p1->mY);
}

- (void)setLength:(float)length {
    if (mX == 0 && mY == 0)
        [NSException raise:SP_EXC_INVALID_OPERATION format:@"Cannot normalize point in the origin"];
    
    float scale = length / self.length;
    mX *= scale;
    mY *= scale;
}

- (void)setAngle:(float)angle {
    float l = self.length;
    mX = l * cosf(angle);
    mY = l * sinf(angle);
}

@dynamic length, angle;

@end
