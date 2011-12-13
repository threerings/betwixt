//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTObject.h"
#import "BTGeneration.h"
#import "BTGeneration+Package.h"

@implementation BTObject

- (NSArray*)names {
    return [NSArray array];
}

- (void)addObject:(BTObject*)object {
    object->_next = _depHead;
    _depHead = object;
    object->_parent = self;
    [self.root attachObject:object];
}

- (BTGeneration*) root {
    if ([_parent isKindOfClass:[BTObject class]]) return ((BTObject*)_parent).root;
    return (BTGeneration*)_parent;
}

@synthesize parent=_parent;

@end
