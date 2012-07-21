//
// Betwixt - Copyright 2012 Three Rings Design

@interface BTPointI : NSObject <NSCopying> {
@private
    int _x;
    int _y;
}

@property (nonatomic,assign) int x;
@property (nonatomic,assign) int y;

+ (BTPointI*)pointWithX:(int)x y:(int)y;
+ (BTPointI*)point;

- (id)initWithX:(int)x y:(int)y;

/// Returns the SPPoint representation of the BTPointI
- (SPPoint*)toPoint;

/// Adds a point to the current point and returns the resulting point.
- (BTPointI*)addPoint:(BTPointI*)point;

/// Substracts a point from the current point and returns the resulting point.
- (BTPointI*)subtractPoint:(BTPointI*)size;

- (BOOL)isEqual:(id)other;

@end
