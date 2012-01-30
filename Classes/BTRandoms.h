//
// Betwixt - Copyright 2012 Three Rings Design

@interface BTRandoms : NSObject

- (id)init;
- (id)initWithSeed:(unsigned int)seed;
- (void)setSeed:(unsigned int)seed;

/**
 * Returns a pseudorandom, uniformly distributed <code>int</code> value between <code>0</code>
 * (inclusive) and <code>high</code> (exclusive).
 */
- (int)getInt:(int)high;

/**
 * Returns a pseudorandom, uniformly distributed <code>int</code> value between
 * <code>low</code> (inclusive) and <code>high</code> (exclusive).
 */
- (int)getIntLow:(int)low high:(int)high;

/**
 * Returns a pseudorandom, uniformly distributed <code>float</code> value between
 * <code>0.0</code> (inclusive) and the <code>high</code> (exclusive).
 */
- (float)getFloat:(float)high;

/**
 * Returns a pseudorandom, uniformly distributed <code>float</code> value between
 * <code>low</code> (inclusive) and <code>high</code> (exclusive).
 */
- (float)getFloatLow:(float)low high:(float)high;

/**
 * Returns <code>YES</code> or <code>NO</code> with approximately even probability.
 */
- (BOOL)getBool;

/**
 * Returns YES approximately one in <code>n</code> times.
 */
- (BOOL)getChance:(int)n;

/**
 * Has a probability <code>p</code> of returning YES.
 */
- (BOOL)getProbability:(float)p;

@end
