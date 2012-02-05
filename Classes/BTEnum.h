//
// Betwixt - Copyright 2012 Three Rings Design

#define BTENUM(NAME) \
    static id _##NAME = nil; \
    + (void)BTEnum_Init##NAME { if (_##NAME == nil) { _##NAME = [[self alloc] initWithName:@#NAME]; } } \
    + (id)NAME { return _##NAME; }


@interface BTEnum : NSObject

+ (id)valueOfEnum:(Class)clazz forName:(NSString *)name;
+ (NSArray *)valuesOfEnum:(Class)clazz;

- (id)initWithName:(NSString *)name;

@property(readonly) NSString *name;
@property(readonly) int ordinal;

@end
