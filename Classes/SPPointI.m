//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPPointI.h"

// --- class implementation ------------------------------------------------------------------------

#define SQ(x) ((x)*(x))

@implementation SPPointI

@synthesize x = mX;
@synthesize y = mY;

// designated initializer
- (id)initWithX:(int)x y:(int)y {
    if ((self = [super init])) {
        mX = x;
        mY = y;        
    }
    return self;
}

- (id)initWithSPPoint:(SPPoint*)p {
    return [self initWithX:(int)p.x y:(int)p.y];
}

- (id)init {
    return [self initWithX:0 y:0];
}

- (int)length {
    return (int)sqrtf(SQ(mX) + SQ(mY));
}

- (int)lengthSquared {
    return SQ(mX) + SQ(mY);
}

- (BOOL)isOrigin {
    return mX == 0 && mY == 0;
}

- (SPPoint*)toSPPoint {
    return [[SPPoint alloc] initWithX:mX y:mY];
}

- (SPPointI*)invert {
    return [[SPPointI alloc] initWithX:-mX y:-mY];
}

- (SPPointI*)addPoint:(SPPointI*)point {
    return [[SPPointI alloc] initWithX:mX+point->mX y:mY+point->mY];
}

- (SPPointI*)subtractPoint:(SPPointI*)point {
    return [[SPPointI alloc] initWithX:mX-point->mX y:mY-point->mY];
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if (!other || ![other isKindOfClass:[self class]]) {
        return NO;
    } else {
        SPPointI* point = (SPPointI*)other;
        return mX == point->mX && mY == point->mY;
    }
}

- (NSUInteger)hash {
    return mX ^ mY;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"(x=%d, y=%d)", mX, mY];
}

+ (int)distanceFromPoint:(SPPointI*)p1 toPoint:(SPPointI*)p2 {
    return (int) sqrtf(SQ(p2->mX - p1->mX) + SQ(p2->mY - p1->mY));
}

+ (SPPointI*)pointWithX:(int)x y:(int)y {
    return [[SPPointI alloc] initWithX:x y:y];
}

+ (SPPointI*)pointWithSPPoint:(SPPoint*)p {
    return [[SPPointI alloc] initWithSPPoint:p];
}

+ (SPPointI*)point {
    return [[SPPointI alloc] init];
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone*)zone {
    return [[SPPointI allocWithZone:zone] initWithX:mX y:mY];
}

#pragma mark SPPoolObject

SP_IMPLEMENT_MEMORY_POOL();

@end

