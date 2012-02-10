//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPRectangle.h"

@interface SPRectangle (OOOExtensions)

/// Sets the bounds of the rectangle.
- (void)setX:(float)x y:(float)y width:(float)width height:(float)height;

/// Expands the bounds of this rectangle to contain the specified point.
- (void)addX:(float)x y:(float)y;

/// Expands the bounds of this rectangle to contain the specified point.
- (void)addPoint:(SPPoint *)p;

@end
