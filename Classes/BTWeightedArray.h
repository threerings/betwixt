//
// Betwixt - Copyright 2012 Three Rings Design

@class BTRandoms;

@interface BTWeightedArray : NSObject {
    BTRandoms* _rands;
    NSMutableArray* _objects;
    BOOL _dirty;
}

@property (readonly) int count;

- (id)initWithRands:(BTRandoms*)rands;
- (void)addObject:(id)object withWeight:(float)weight;
- (id)nextObject;
- (NSArray*)allObjects;

@end
