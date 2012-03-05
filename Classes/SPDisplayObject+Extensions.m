//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPDisplayObject+Extensions.h"

@implementation SPDisplayObject (OOOExtensions)

- (SPPoint*)loc {
    return [SPPoint pointWithX:self.x y:self.y];
}

- (void)setLoc:(SPPoint*)loc {
    self.x = loc.x;
    self.y = loc.y;
}

- (SPPoint*)pivot {
    return [SPPoint pointWithX:self.pivotX y:self.pivotY];
}

- (void)setPivot:(SPPoint*)pivot {
    self.pivotX = pivot.x;
    self.pivotY = pivot.y;
}

- (SPPoint*)scale {
    return [SPPoint pointWithX:self.scaleX y:self.scaleY];
}

- (void)setScale:(SPPoint*)scale
{
    self.scaleX = scale.x;
    self.scaleY = scale.y;
}

// These are already implemented by SPDisplayObject
@dynamic x;
@dynamic y;

@end
