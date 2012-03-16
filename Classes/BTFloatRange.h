//
// Betwixt - Copyright 2012 Three Rings Design

@class BTRandoms;

@interface BTFloatRange : NSObject

@property(nonatomic,strong) BTRandoms* rands;
@property(nonatomic,assign) float min;
@property(nonatomic,assign) float max;

- (id)initWithMin:(float)min max:(float)max rands:(BTRandoms*)rands;

/// Returns a float between [min, max)
- (float)next;

@end
