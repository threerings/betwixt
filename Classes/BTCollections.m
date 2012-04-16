//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTCollections.h"
#import "BTUtils.h"

@implementation BTCollections

+ (NSMutableArray*)filter:(id<NSFastEnumeration>)collection pred:(BOOL (^)(id))pred {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (id obj in collection) {
        if (pred(obj)) {
            [array addObject:obj];
        }
    }
    return array;
}

+ (NSMutableArray*)map:(id<NSFastEnumeration>)collection transformer:(id (^)(id))transformer {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (id obj in collection) {
        [array addObject:BTNilToNSNull(transformer(obj))];
    }
    return array;
}

+ (id)findObject:(id<NSFastEnumeration>)collection pred:(BOOL (^)(id))pred {
    for (id obj in collection) {
        if (pred(obj)) {
            return obj;
        }
    }
    return nil;
}

@end
