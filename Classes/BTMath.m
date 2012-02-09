//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMath.h"

#define SQ(x) ((x)*(x))

@implementation BTMath

+ (float) distanceFromX:(float)fromX fromY:(float)fromY toX:(float)toX toY:(float)toY {
    return sqrtf([BTMath distanceSqFromX:fromX fromY:fromY toX:toX toY:toY]);
}

+ (float) distanceFrom:(SPPoint*)p1 to:(SPPoint*)p2 {
    return [BTMath distanceFromX:p1.x fromY:p1.y toX:p2.x toY:p2.y];
}

+ (float) distanceSqFromX:(float)fromX fromY:(float)fromY toX:(float)toX toY:(float)toY {
    return SQ(toX - fromX) + SQ(toY - fromY);
}

+ (float) distanceSqFrom:(SPPoint*)p1 to:(SPPoint*)p2 {
    return [BTMath distanceSqFromX:p1.x fromY:p1.y toX:p2.x toY:p2.y];
}

@end
