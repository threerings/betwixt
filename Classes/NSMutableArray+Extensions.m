//
// Betwixt - Copyright 2012 Three Rings Design

#import "NSMutableArray+Extensions.h"
#import "NSArray+Extensions.h"

@implementation NSMutableArray (OOOExtensions)

- (int)sortedInsert:(id)object comp:(NSComparator)comp {
    int index = [self binarySearch:object comp:comp];
    if (index < 0) {
        index = -(index + 1);
    }
    [self insertObject:object atIndex:index];
    return index;
}

@end
