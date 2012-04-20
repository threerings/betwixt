//
// Betwixt - Copyright 2012 Three Rings Design

#define BT_ENUM(NAME) \
    static id _##NAME = nil; \
    + (void)BTEnum_Init##NAME { \
        if (_##NAME == nil) { \
            _##NAME = [[self alloc] init]; \
            [_##NAME setName:@#NAME]; \
        } \
    } \
    + (id)NAME { return _##NAME; }

#define BT_ENUM_INIT(NAME, INIT) \
    static id _##NAME = nil; \
    + (void)BTEnum_Init##NAME { \
        if (_##NAME == nil) { \
            _##NAME = INIT; \
            [_##NAME setName:@#NAME]; \
        } \
    } \
    + (id)NAME { return _##NAME; }


@interface BTEnum : NSObject <NSCopying>

+ (id)valueOf:(NSString*)name;
+ (NSArray*)values;

@property(readonly) NSString* name;

@end
