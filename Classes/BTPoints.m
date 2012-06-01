//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTPoints.h"

#define SQ(x) ((x)*(x))

@implementation BTPoints

+ (float)distanceFromX:(float)fromX fromY:(float)fromY toX:(float)toX toY:(float)toY {
    return sqrtf([BTPoints distanceSqFromX:fromX fromY:fromY toX:toX toY:toY]);
}

+ (float)distanceFrom:(SPPoint*)p1 to:(SPPoint*)p2 {
    return [BTPoints distanceFromX:p1.x fromY:p1.y toX:p2.x toY:p2.y];
}

+ (float)distanceSqFromX:(float)fromX fromY:(float)fromY toX:(float)toX toY:(float)toY {
    return SQ(toX - fromX) + SQ(toY - fromY);
}

+ (float)distanceSqFrom:(SPPoint*)p1 to:(SPPoint*)p2 {
    return [BTPoints distanceSqFromX:p1.x fromY:p1.y toX:p2.x toY:p2.y];
}

@end
