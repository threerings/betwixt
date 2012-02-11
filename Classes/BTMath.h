//
// Betwixt - Copyright 2012 Three Rings Design

#define CLAMP(val,min,max) ((val)<(min)?(min):((val)>(max)?(max):(val)))

@interface BTMath : NSObject

+ (float)distanceFromX:(float)fromX fromY:(float)fromY toX:(float)toX toY:(float)toY;
+ (float)distanceFrom:(SPPoint*)p1 to:(SPPoint*)p2;
+ (float)distanceSqFromX:(float)fromX fromY:(float)fromY toX:(float)toX toY:(float)toY;
+ (float)distanceSqFrom:(SPPoint*)p1 to:(SPPoint*)p2;

@end
