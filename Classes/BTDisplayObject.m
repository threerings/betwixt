//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObject.h"

@interface BTSimpleDisplayObject : BTDisplayObject
- (id)initWithDisplayObject:(SPDisplayObject *)disp;
@end

@implementation BTDisplayObject

- (float)x {
    return self.display.x;
}

- (float)y {
    return self.display.y;
}

- (void)setX:(float)x {
    self.display.x = x;
}

- (void)setY:(float)y {
    self.display.y = y;
}

- (SPDisplayObject *)display {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (BTDisplayObject *)create:(SPDisplayObject *)disp {
    return [[BTSimpleDisplayObject alloc] initWithDisplayObject:disp];
}

@end

@implementation BTSimpleDisplayObject {
@private
    SPDisplayObject *_disp;
}

- (id)initWithDisplayObject:(SPDisplayObject *)disp {
    if (!(self = [super init])) {
        return nil;
    }
    _disp = disp;
    return self;
}

@synthesize display=_disp;

@end
