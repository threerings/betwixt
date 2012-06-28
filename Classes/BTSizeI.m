//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTSizeI.h"

@implementation BTSizeI

@synthesize width = _width;
@synthesize height = _height;

+ (BTSizeI*)sizeWithWidth:(int)width height:(int)height {
    return [[BTSizeI alloc] initWithWidth:width height:height];
}

+ (BTSizeI*)size {
    return [[BTSizeI alloc] init];
}

- (id)initWithWidth:(int)width height:(int)height {
    if ((self = [super init])) {
        _width = width;
        _height = height;
    }
    return self;
}

- (id)init {
    return [self initWithWidth:0 height:0];
}

- (SPPoint*)toPoint {
    return [[SPPoint alloc] initWithX:_width y:_height];
}

- (BTSizeI*)addSize:(BTSizeI*)size {
    return [[BTSizeI alloc] initWithWidth:_width + size->_width height:_height + size->_height];
}

- (BTSizeI*)subtractSize:(BTSizeI *)size {
    return [[BTSizeI alloc] initWithWidth:_width - size->_width height:_height - size->_height];
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if (!other || ![other isKindOfClass:[self class]]) {
        return NO;
    } else {
        BTSizeI* o = (BTSizeI*)other;
        return (_width == o->_width && _height == o->_height);
    }
}

- (NSUInteger)hash {
    return _width ^ _height;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"(width=%d, height=%d)", _width, _height];
}

- (id)copyWithZone:(NSZone*)zone {
    return [[BTSizeI allocWithZone:zone] initWithWidth:_width height:_height];
}

SP_IMPLEMENT_MEMORY_POOL();

@end

