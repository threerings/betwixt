//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTObject.h"
#import "BTGeneration.h"
#import "BTGeneration+Package.h"

@implementation BTObject

- (void)addDependentObject:(BTObject*)object {
    object->_next = _depHead;
    _depHead = object;
    [_gen attachObject:object];
}

- (NSArray*)names {
    return [NSArray array];
}

@end
