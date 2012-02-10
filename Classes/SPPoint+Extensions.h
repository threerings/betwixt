//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPPoint.h"

@interface SPPoint (OOOExtensions)

/// Sets this point's coords to those of the specfied point
- (void)set:(SPPoint *)pt;

/// Sets this point's coords
- (void)setX:(int)x y:(int)y;

/// Adds a point to the current point and returns the resulting point.
- (SPPoint *)addX:(float)x y:(float)y;

/// Substracts a point from the current point and returns the resulting point.
- (SPPoint *)subtractX:(float)x y:(float)y;

+ (float)distanceSqFromPoint:(SPPoint *)p1 toPoint:(SPPoint *)p2;

@end
