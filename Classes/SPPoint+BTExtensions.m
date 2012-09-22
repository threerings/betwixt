//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPPoint+BTExtensions.h"
#import <math.h>

#define SQ(x) ((x)*(x))

@implementation SPPoint (BTExtensions)

+ (SPPoint*)pointFromString:(NSString*)string {
    NSArray* items = [string componentsSeparatedByString:@","];
    if (items.count != 2) {
        return nil;
    }

    @try {
        return [SPPoint pointWithX:[items[0] requireFloatValue]
                                 y:[items[1] requireFloatValue]];
    } @catch (...) {
        return nil;
    }
}

- (BOOL)isEquivalent:(SPPoint*)p {
    return SP_IS_FLOAT_EQUAL(mX, p->mX) && SP_IS_FLOAT_EQUAL(mY, p->mY);
}

- (void)set:(SPPoint *)pt {
    mX = pt.x;
    mY = pt.y;
}

- (void)setX:(int)x y:(int)y {
    mX = x;
    mY = y;
}

- (SPPoint*)addX:(float)x y:(float)y {
    return [[SPPoint alloc] initWithX:mX+x y:mY+y];
}

- (SPPoint*)subtractX:(float)x y:(float)y {
    return [[SPPoint alloc] initWithX:mX-x y:mY-y];
}

- (SPPoint*)scaleByX:(float)x y:(float)y {
    return [[SPPoint alloc] initWithX:mX*x y:mY*y];
}

- (float)distanceSqToPoint:(SPPoint *)p {
    return [SPPoint distanceSqFromPoint:self toPoint:p];
}

- (float)distanceToPoint:(SPPoint *)p {
    return [SPPoint distanceFromPoint:self toPoint:p];
}

+ (float)distanceSqFromPoint:(SPPoint *)p1 toPoint:(SPPoint *)p2 {
    return [SPPoint distanceSqFromX:p1.x fromY:p1.y toX:p2.x toY:p2.y];
}

+ (float)distanceSqFromX:(float)fromX fromY:(float)fromY toX:(float)toX toY:(float)toY {
    return SQ(toX - fromX) + SQ(toY - fromY);
}

+ (float)distanceFromX:(float)fromX fromY:(float)fromY toX:(float)toX toY:(float)toY {
    return sqrtf([SPPoint distanceSqFromX:fromX fromY:fromY toX:toX toY:toY]);
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
