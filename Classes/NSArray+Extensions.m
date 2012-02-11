//
// Betwixt - Copyright 2012 Three Rings Design

#import "NSArray+Extensions.h"

@implementation NSArray (OOOExtensions)

- (NSMutableArray *)filter:(BOOL (^)(id))block {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (id obj in self) {
        if (block(obj)) {
            [array addObject:obj];
        }
    }
    return array;
}

- (NSMutableArray *)map:(id (^)(id))block {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.count];
    for (id obj in self) {
        [array addObject:block(obj)];
    }
    return array;
}

@end
