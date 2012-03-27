//
// Betwixt - Copyright 2012 Three Rings Design

#import <Foundation/Foundation.h>
#import "SPPoolObject.h"

/** The SPPointI class describes a two dimensional point or vector. */

@interface SPPointI : SPPoolObject <NSCopying>
{
@private
    int mX;
    int mY;
}

/// ------------------
/// @name Initializers
/// ------------------

/// Initializes a point with its x and y components. _Designated Initializer_.
- (id)initWithX:(int)x y:(int)y;

- (id)initWithSPPoint:(SPPoint*)p;

/// Factory method.
+ (SPPointI*)pointWithX:(int)x y:(int)y;

/// Factory method
+ (SPPointI*)pointWithSPPoint:(SPPoint*)p;

/// Factory method.
+ (SPPointI*)point;

/// -------------
/// @name Methods
// --------------

/// Returns the SPPoint representation of the point
- (SPPoint*)toSPPoint;

/// Adds a point to the current point and returns the resulting point.
- (SPPointI*)addPoint:(SPPointI*)point;

/// Substracts a point from the current point and returns the resulting point.
- (SPPointI*)subtractPoint:(SPPointI*)point;

/// Returns a point that is the inverse (negation) of this point.
- (SPPointI*)invert;

/// Compares two points.
- (BOOL)isEqual:(id)other;

/// Calculates the distance between two points.
+ (int)distanceFromPoint:(SPPointI*)p1 toPoint:(SPPointI*)p2;

/// ----------------
/// @name Properties
/// ----------------

/// The x-Coordinate of the point.
@property (nonatomic, assign) int x;

/// The y-Coordinate of the point.
@property (nonatomic, assign) int y;

/// The distance to the origin (or the length of the vector).
@property (readonly) int length;

/// The squared distance to the origin (or the squared length of the vector)
@property (readonly) int lengthSquared;

/// Returns true if this point is in the origin (x and y equal zero).
@property (readonly) BOOL isOrigin;

@end
