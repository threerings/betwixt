//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPDisplayObject+BTExtensions.h"

@implementation SPDisplayObject (BTExtensions)

// implemented by SPDisplayObject
@dynamic x;
@dynamic y;

- (SPPoint*)loc {
    return [SPPoint pointWithX:self.x y:self.y];
}

- (void)setLoc:(SPPoint*)loc {
    self.x = loc.x;
    self.y = loc.y;
}

- (SPPoint*)globalLoc {
    SPPoint* loc = self.loc;
    if (self.parent != nil) {
        loc = [self.parent localToGlobal:loc];
    }
    return loc;
}

- (void)setGlobalLoc:(SPPoint*)globalLoc {
    if (self.parent != nil) {
        globalLoc = [self.parent globalToLocal:globalLoc];
    }
    self.loc = globalLoc;
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

@end
