//
// Betwixt - Copyright 2012 Three Rings Design

@interface NSArray (OOOExtensions)

- (NSMutableArray*)filter:(BOOL (^)(id object))pred;
- (NSMutableArray*)map:(id (^)(id object))transformer;
- (id)findObject:(BOOL (^)(id object))pred;

/**
 * Performs a binary search, attempting to locate the specified
 * object. The array must be in the sort order defined by the supplied
 * comparator function for this to operate correctly.
 *
 * @param offset the index of the first element in the array to be* considered.
 * @param length the number of elements including and following the
 * element at <code>offset</code> to consider when searching.
 *
 * @return the index of the object in question or
 * <code>(-(<i>insertion point</i>) - 1)</code> (always a negative
 * value) if the object was not found in the list.
 */
- (int)binarySearch:(id)object offset:(int)offset length:(int)length comp:(NSComparator)comp;

- (int)binarySearch:(id)object comp:(NSComparator)comp;

@end
