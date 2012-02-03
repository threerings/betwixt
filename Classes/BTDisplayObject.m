//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObject.h"

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

@end
