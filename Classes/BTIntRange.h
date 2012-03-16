//
// Betwixt - Copyright 2012 Three Rings Design

@class BTRandoms;

@interface BTIntRange : NSObject

@property(nonatomic,strong) BTRandoms* rands;
@property(nonatomic,assign) int min;
@property(nonatomic,assign) int max;

- (id)initWithMin:(int)min max:(int)max rands:(BTRandoms*)rands;

/// Returns an int between [min, max]
- (int)next;

@end
