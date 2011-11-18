//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTObject.h"

@implementation BTObject
- (id)init {
    if (!(self = [super init])) return nil;
    _removed = NO;
    return self;
}

// Stublets
-(void)addedToGen {}
-(void)removedFromGen {}
-(void)advanceTime:(double)seconds {}

@end
