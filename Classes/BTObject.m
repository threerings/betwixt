//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTObject.h"
#import "BTGeneration.h"

@implementation BTObject
- (id)init {
    if (!(self = [super init])) return nil;
    _removed = NO;
    return self;
}

-(void)addDependentObject:(BTObject *)object {
    object->_next = _depHead;
    _depHead = object;
    [_gen attachObject:object];
}

-(NSArray*)names {
    return [NSArray array];
}

// Stublets
-(void)addedToGen {}
-(void)removedFromGen {}
-(void)advanceTime:(double)seconds {}

@end
