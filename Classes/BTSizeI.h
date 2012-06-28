//
// Betwixt - Copyright 2012 Three Rings Design

@interface BTSizeI : SPPoolObject <NSCopying> {
@private
    int _width;
    int _height;
}

@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;

+ (BTSizeI*)sizeWithWidth:(int)width height:(int)height;
+ (BTSizeI*)size;

- (id)initWithWidth:(int)width height:(int)height;

/// Returns the SPPoint representation of the size
- (SPPoint*)toPoint;

/// Adds a size to the current size and returns the resulting size.
- (BTSizeI*)addSize:(BTSizeI*)size;

/// Substracts a size from the current size and returns the resulting size.
- (BTSizeI*)subtractSize:(BTSizeI*)size;

- (BOOL)isEqual:(id)other;

@end
