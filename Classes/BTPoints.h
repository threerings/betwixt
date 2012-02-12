

@interface BTPoints : NSObject

+ (float)distanceFromX:(float)fromX fromY:(float)fromY toX:(float)toX toY:(float)toY;
+ (float)distanceFrom:(SPPoint*)p1 to:(SPPoint*)p2;
+ (float)distanceSqFromX:(float)fromX fromY:(float)fromY toX:(float)toX toY:(float)toY;
+ (float)distanceSqFrom:(SPPoint*)p1 to:(SPPoint*)p2;

@end
