//
// Betwixt - Copyright 2012 Three Rings Design

@interface NSArray (OOOExtensions)

- (NSMutableArray *)filter:(BOOL (^)(id object))block;
- (NSMutableArray *)map:(id (^)(id object))block;
- (id)findObject:(BOOL (^)(id object))block;

@end
