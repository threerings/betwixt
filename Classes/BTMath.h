//
// Betwixt - Copyright 2012 Three Rings Design

@interface BTMath : NSObject

+ (float) distanceX1:(float)x1 y1:(float)y1 x2:(float)x2 y2:(float)y2;
+ (float) distanceP1:(SPPoint *)p1 p2:(SPPoint *)p2;
+ (float) distanceSqX1:(float)x1 y1:(float)y1 x2:(float)x2 y2:(float)y2;
+ (float) distanceSqP1:(SPPoint *)p1 p2:(SPPoint *)p2;

@end
