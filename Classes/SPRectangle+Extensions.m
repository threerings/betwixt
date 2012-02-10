//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPRectangle+Extensions.h"

@implementation SPRectangle (OOOExtensions)

- (void)setX:(float)x y:(float)y width:(float)width height:(float)height {
    mX = x;
    mY = y;
    mWidth = width;
    mHeight = height;
}

- (void)addX:(float)x y:(float)y {
    float x1 = MIN(mX, x);
    float x2 = MAX(mX + mWidth, x);
    float y1 = MIN(mY, y);
    float y2 = MAX(mY + mHeight, y);
    [self setX:x1 y:y1 width:x2 - x1 height:y2 - y1];
}

- (void)addPoint:(SPPoint *)p {
    [self addX:p.x y:p.y];
}

@end
