//
// Betwixt - Copyright 2012 Three Rings Design

@interface NSMutableArray (OOOExtensions)

/// Creates a mutable array from an NSFastEnumeration.
/// nil objects in the enumeration will be converted to NSNulls in the array.
+ (NSMutableArray*)arrayFromEnumeration:(id<NSFastEnumeration>)e;

/**
 * Inserts an object into a sorted Array in its correct, sorted location.
 *
 * @param comp a function that takes two objects in the array and returns -1 if the first
 * object should appear before the second in the container, 1 if it should appear after,
 * and 0 if the order does not matter.
 *
 * @return the index of the inserted item
 */
- (int)sortedInsert:(id)object comp:(NSComparator)comp;

@end
