//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTObject.h"
#import "BTNode+Package.h"

@implementation BTObject

- (void)removeInternal {
    NSMutableSet *kids = _children;
    _children = nil;
    for (BTObject *child in kids) {
        [child removeInternal];
    }
    [super removeInternal];
}

@end
