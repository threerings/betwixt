//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPRectangle+BTExtensions.h"
#import "SPPoint+BTExtensions.h"
#import <math.h>

@implementation SPRectangle (BTExtensions)

+ (SPRectangle*)rectangleFromString:(NSString*)string {
    NSArray* items = [string componentsSeparatedByString:@","];
    if (items.count != 4) {
        return nil;
    }
    
    @try {
        return [SPRectangle rectangleWithX:[[items objectAtIndex:0] requireFloatValue]
                                         y:[[items objectAtIndex:1] requireFloatValue] 
                                     width:[[items objectAtIndex:2] requireFloatValue] 
                                    height:[[items objectAtIndex:3] requireFloatValue]];
    } @catch (...) {
        return nil;
    }
}

- (float)centerX {
    return mX + (mWidth / 2);
}

- (float)centerY {
    return mY + (mHeight / 2);
}

- (SPPoint*)center {
    return [SPPoint pointWithX:self.centerX y:self.centerY];
}

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

- (void)scaleByX:(float)scaleX y:(float)scaleY {
    mX *= scaleX;
    mWidth *= scaleX;
    mY *= scaleY;
    mHeight *= scaleY;
}

- (void)scaleBy:(float)scale {
    [self scaleByX:scale y:scale];
}

- (SPPoint*)closestInteriorPointTo:(SPPoint *)p {
    return [SPPoint pointWithX:SP_CLAMP(p.x, self.left, self.right) 
                             y:SP_CLAMP(p.y, self.top, self.bottom)];
}

- (float)distanceSqToPoint:(SPPoint *)p {
    SPPoint* p2 = [self closestInteriorPointTo:p];
    return [SPPoint distanceSqFromPoint:p toPoint:p2];
}

- (float)distanceToPoint:(SPPoint *)p {
    return sqrtf([self distanceSqToPoint:p]);
}

- (CGRect)toCGRect {
    return CGRectMake(mX, mY, mWidth, mHeight);
}

@end
