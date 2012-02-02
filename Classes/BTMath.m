//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMath.h"

#define SQ(x) ((x)*(x))

@implementation BTMath

+ (float) distanceX1:(float)x1 y1:(float)y1 x2:(float)x2 y2:(float)y2 {
    return sqrtf([BTMath distanceSqX1:x1 y1:y1 x2:x2 y2:y2]);
}

+ (float) distanceP1:(SPPoint *)p1 p2:(SPPoint *)p2 {
    return [BTMath distanceX1:p1.x y1:p1.y x2:p2.x y2:p2.y];
}

+ (float) distanceSqX1:(float)x1 y1:(float)y1 x2:(float)x2 y2:(float)y2 {
    return SQ(x2 - x1) + SQ(y2 - y1);
}

+ (float) distanceSqP1:(SPPoint *)p1 p2:(SPPoint *)p2 {
    return [BTMath distanceSqX1:p1.x y1:p1.y x2:p2.x y2:p2.y];
}

@end
