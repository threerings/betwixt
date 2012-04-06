//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTWeightedArray.h"
#import "BTRandoms.h"
#import "NSArray+Extensions.h"

@interface WeightedObject : NSObject
@property (readonly) id obj;
@property (readonly) float weight;
@property float min;
@property (readonly) float max;
- (id)initWithObj:(id)obj weight:(float)weight;
@end

@implementation WeightedObject {
    id _obj;
    float _weight;
}
@synthesize obj = _obj;
@synthesize weight = _weight;
@synthesize min;
- (id)initWithObj:(id)obj weight:(float)weight {
    if (!(self = [super init])) {
        return nil;
    }
    _obj = obj;
    _weight = weight;
    return self;
}

- (float)max {
    return min + _weight;
}

@end

@implementation BTWeightedArray

- (id)initWithRands:(BTRandoms*)rands {
    if (!(self = [super init])) {
        return nil;
    }
    _rands = rands;
    _objects = [NSMutableArray array];
    return self;
}

- (void)addObject:(id)object withWeight:(float)weight {
    NSAssert(weight > 0, @"weight must be > 0");
    [_objects addObject:[[WeightedObject alloc] initWithObj:object weight:weight]];
    _dirty = YES;
}

- (id)nextObject {
    [self updateObjects];
    if (_objects.count == 0) {
        return nil;
    }
    
    float max = ((WeightedObject*)[_objects lastObject]).max;
    float val = [_rands getFloatLow:0 high:max];
    
    // binary-search the WeightedObjects
    int loIdx = 0;
    int hiIdx = _objects.count - 1;
    for (;;) {
        NSAssert(loIdx <= hiIdx, @"something's broken");
        int idx = loIdx + ((hiIdx - loIdx) / 2);
        WeightedObject* wo = [_objects objectAtIndex:idx];
        if (val < wo.min) {
            // too high
            hiIdx = idx - 1;
        } else if (val >= wo.max) {
            // too low
            loIdx = idx + 1;
        } else {
            // hit
            return wo.obj;
        }
    }
}

- (int)count {
    return _objects.count;
}

- (NSArray*)allObjects {
    return [_objects map:^id(WeightedObject* wo) {
        return wo.obj;
    }];
}

- (void)updateObjects {
    if (!_dirty) {
        return;
    }
    float totalWeight = 0;
    for (WeightedObject* wo in _objects) {
        wo.min = totalWeight;
        totalWeight += wo.weight;
    }
    _dirty = NO;
}

@end
