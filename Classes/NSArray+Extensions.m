//
// Betwixt - Copyright 2012 Three Rings Design

#import "NSArray+Extensions.h"
#import "BTUtils.h"
#import "BTCollections.h"

@implementation NSArray (OOOExtensions)

- (NSMutableArray*)filter:(BOOL (^)(id))pred {
    return [BTCollections filter:self pred:pred];
}

- (NSMutableArray*)map:(id (^)(id))transformer {
    return [BTCollections map:self transformer:transformer];
}

- (id)findObject:(BOOL (^)(id))pred {
    return [BTCollections findObject:self pred:pred];
}

- (int)binarySearch:(id)object offset:(int)offset length:(int)length comp:(NSComparator)comp {
    int low = offset;
    int high = offset + length - 1;
    while (low <= high) {
        int mid = ((unsigned int)low + (unsigned int)high) >> 1;
        id midVal = [self objectAtIndex:mid];
        int cmp = comp(midVal, object);
        if (cmp < 0) {
            low = mid + 1;
        } else if (cmp > 0) {
            high = mid - 1;
        } else {
            return mid; // key found
        }
    }
    return -(low + 1); // key not found.
}

- (int)binarySearch:(id)object comp:(NSComparator)comp {
    return [self binarySearch:object offset:0 length:self.count comp:comp];
}

@end
