//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTPointI.h"

@implementation BTPointI

@synthesize x = _x;
@synthesize y = _y;

+ (BTPointI*)pointWithX:(int)x y:(int)y {
    return [[BTPointI alloc] initWithX:x y:y];
}

+ (BTPointI*)point {
    return [[BTPointI alloc] init];
}

- (id)initWithX:(int)x y:(int)y {
    if ((self = [super init])) {
        _x = x;
        _y = y;
    }
    return self;
}

- (id)init {
    return [self initWithX:0 y:0];
}

- (SPPoint*)toPoint {
    return [[SPPoint alloc] initWithX:_x y:_y];
}

- (BTPointI*)addPoint:(BTPointI*)p {
    return [[BTPointI alloc] initWithX:_x + p->_x y:_y + p->_y];
}

- (BTPointI*)subtractPoint:(BTPointI *)p {
    return [[BTPointI alloc] initWithX:_x - p->_x y:_y - p->_y];
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if (!other || ![other isKindOfClass:[self class]]) {
        return NO;
    } else {
        BTPointI* o = (BTPointI*)other;
        return (_x == o->_x && _y == o->_y);
    }
}

- (NSUInteger)hash {
    return _x ^ _y;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"(x=%d, y=%d)", _x, _y];
}

- (id)copyWithZone:(NSZone*)zone {
    return [[BTPointI allocWithZone:zone] initWithX:_x y:_y];
}

@end

