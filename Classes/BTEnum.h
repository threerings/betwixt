//
// Betwixt - Copyright 2012 Three Rings Design

#define BTENUM(NAME) \
    static id _##NAME = nil; \
    + (void)BTEnum_Init##NAME { \
        if (_##NAME == nil) { \
            _##NAME = [[self alloc] init]; \
            [_##NAME setName:@#NAME]; \
        } \
    } \
    + (id)NAME { return _##NAME; }

#define BTENUM_INIT(NAME, INIT) \
    static id _##NAME = nil; \
    + (void)BTEnum_Init##NAME { \
        if (_##NAME == nil) { \
            _##NAME = INIT; \
            [_##NAME setName:@#NAME]; \
        } \
    } \
    + (id)NAME { return _##NAME; }


@interface BTEnum : NSObject

+ (id)valueOf:(NSString*)name;
+ (NSArray*)values;

@property(readonly) NSString* name;
@property(readonly) int ordinal;

@end
