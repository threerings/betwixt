//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPRectangle.h"

@interface SPRectangle (OOOExtensions)

@property(nonatomic,readonly) float centerX;
@property(nonatomic,readonly) float centerY;
@property(nonatomic,readonly) SPPoint* center;

/// Sets the bounds of the rectangle.
- (void)setX:(float)x y:(float)y width:(float)width height:(float)height;

/// Expands the bounds of this rectangle to contain the specified point.
- (void)addX:(float)x y:(float)y;

/// Expands the bounds of this rectangle to contain the specified point.
- (void)addPoint:(SPPoint *)p;

/// scales this rectangle by the given amount
- (void)scaleByX:(float)scaleX y:(float)scaleY;

/// Uniformly scales this rectangle by the given amount
- (void)scaleBy:(float)scale;

/// Computes the point inside the bounds of the rectangle that's closest to the given point.
- (SPPoint*)closestInteriorPointTo:(SPPoint*)p;

/// Returns the squared Euclidean distance between the given point and the nearest point
/// inside the bounds of the rectangle. If the supplied points is inside the rectangle,
/// the distance will be 0.
- (float)distanceSqToPoint:(SPPoint*)p;

/// Returns the Euclidean distance between the given point and the nearest point
/// inside the bounds of the rectangle. If the supplied points is inside the rectangle,
/// the distance will be 0.
- (float)distanceToPoint:(SPPoint*)p;

@end
