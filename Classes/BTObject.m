//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTObject.h"
#import "BTGeneration.h"

@implementation BTObject

- (id)init {
    if (!(self = [super init])) return nil;
    return self;
}

- (void)addDependentObject:(BTObject*)object {
    object->_next = _depHead;
    _depHead = object;
    [_gen attachObject:object];
}

- (NSArray*)names {
    return [NSArray array];
}

- (void)advanceTime:(double)seconds {}

@synthesize added, removed;

@end
