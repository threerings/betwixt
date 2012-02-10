//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPPoint.h"

@interface SPPoint (OOOExtensions)

/// Adds a point to the current point and returns the resulting point.
- (SPPoint *)addX:(float)x y:(float)y;

/// Substracts a point from the current point and returns the resulting point.
- (SPPoint *)subtractX:(float)x y:(float)y;

+ (float)distanceSqFromPoint:(SPPoint *)p1 toPoint:(SPPoint *)p2;

@end
