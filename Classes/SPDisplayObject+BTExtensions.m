//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPDisplayObject+BTExtensions.h"
#import "SPDisplayObjectContainer.h"

static BOOL traverseInternal (SPDisplayObject* disp, BTTraverseCallback filter, 
                              BTTraverseCallback callback) {
    if (filter != nil && !filter(disp)) {
        return YES;
    }
    
    if ([disp isKindOfClass:[SPDisplayObjectContainer class]]) {
        SPDisplayObjectContainer* container = (SPDisplayObjectContainer*)disp;
        int numChildren = container.numChildren;
        for (int ii = numChildren - 1; ii >= 0; ii--) {
            SPDisplayObject* child = [container childAtIndex:ii];
            if (!traverseInternal(child, filter, callback)) {
                return NO;
            }
        }
    }
    
    return callback(disp);
}

@implementation SPDisplayObject (BTExtensions)

// implemented by SPDisplayObject
@dynamic x;
@dynamic y;

+ (SPPoint*)transformPoint:(SPPoint*)pt from:(SPDisplayObject*)from to:(SPDisplayObject*)to {
    return [to globalToLocal:[from localToGlobal:pt]];
}

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

- (void)setScale:(SPPoint*)scale {
    self.scaleX = scale.x;
    self.scaleY = scale.y;
}

- (void)traverse:(BTTraverseCallback)callback {
    traverseInternal(self, nil, callback);
}

- (void)traverseWithFilter:(BTTraverseCallback)filter callback:(BTTraverseCallback)callback {
    traverseInternal(self, filter, callback);
}

@end
