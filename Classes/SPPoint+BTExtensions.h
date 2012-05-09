//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPPoint.h"

@interface SPPoint (BTExtensions)

@property (nonatomic,assign) float length;
@property (nonatomic,assign) float angle;

/// Converts a String in the form "x,y" into an SPPoint.
/// Returns nil if the string could not be converted.
+ (SPPoint*)pointFromString:(NSString*)string;

/// Returns YES if this point is equal to the given point within epsilon
- (BOOL)isEquivalent:(SPPoint*)p;

/// Sets this point's coords to those of the specfied point
- (void)set:(SPPoint *)pt;

/// Sets this point's coords
- (void)setX:(int)x y:(int)y;

/// Adds a point to the current point and returns the resulting point.
- (SPPoint *)addX:(float)x y:(float)y;

/// Substracts a point from the current point and returns the resulting point.
- (SPPoint*)subtractX:(float)x y:(float)y;

/// Scales the point by the given x and y scale values, and returns the resulting point
- (SPPoint*)scaleByX:(float)x y:(float)y;

- (float)distanceSqToPoint:(SPPoint*)p;

- (float)distanceToPoint:(SPPoint*)p;

+ (float)distanceSqFromPoint:(SPPoint *)p1 toPoint:(SPPoint *)p2;

+ (float)distanceFromX:(float)fromX fromY:(float)fromY toX:(float)toX toY:(float)toY;

+ (float)distanceSqFromX:(float)fromX fromY:(float)fromY toX:(float)toX toY:(float)toY;

@end
