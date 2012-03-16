//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTIntRange.h"
#import "BTRandoms.h"

@implementation BTIntRange

@synthesize rands, min, max;

- (id)initWithMin:(int)theMin max:(int)theMax rands:(BTRandoms*)theRands {
    if (!(self = [super init])) {
        return nil;
    }
    self.min = theMin;
    self.max = theMax;
    self.rands = theRands;
    return self;
}

- (int)next {
    return [rands getIntLow:min high:max + 1];
}

@end
