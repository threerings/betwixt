//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTEnum.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface BTEnum ()
+ (NSMutableDictionary*)enums;
+ (NSMutableSet*)blocked;
@end

@implementation BTEnum {
    NSString* _name;
    int _ordinal;
}

+ (id)valueOf:(NSString*)name {
    for (BTEnum* theEnum in [self values]) {
        if ([theEnum.name isEqualToString:name]) {
            return theEnum;
        }
    }
    return nil;
}

+ (NSArray*)values {
    return [[BTEnum enums] objectForKey:[self class]];
}

- (id)init {
    if (!(self = [super init])) {
        return nil;
    }
    Class clazz = [self class];
    if ([[BTEnum blocked] containsObject:clazz]) {
        [NSException raise:NSGenericException format:@"You may not just construct an enum!"];
    }
    
    NSMutableArray* array = [[BTEnum enums] objectForKey:clazz];
    if (array == nil) {
        array = [NSMutableArray array];
        [[BTEnum enums] setObject:array forKey:clazz];
    }
    [array addObject:self];
    
    _ordinal = array.count - 1;
    return self;
}

- (void)setName:(NSString*)name {
    NSAssert(_name == nil, @"name already set");
    _name = name;
}

- (BOOL)isEqual:(id)object {
    return object == self;
}

- (NSUInteger)hash {
    return _name.hash;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@.%@", [self class].description, self.name];
}

+ (NSMutableDictionary*)enums {
    static NSMutableDictionary* enums = nil;
    if (enums == nil) {
        enums = [NSMutableDictionary dictionary];
    }
    return enums;
}

+ (NSMutableSet*)blocked {
    static NSMutableSet* blocked = nil;
    if (blocked == nil) {
        blocked = [NSMutableSet set];
    }
    return blocked;
}

+ (void)initialize {
    static NSString* PREFIX = @"BTEnum_Init";
    
    if (self != [BTEnum class]) {
        // walk the class methods 
        unsigned int methodCount = 0;
        Method* mlist = class_copyMethodList(object_getClass(self), &methodCount);
        for (unsigned int ii = 0; ii < methodCount; ++ii) {
            NSString* mname = NSStringFromSelector(method_getName(mlist[ii]));
            if (mname.length > PREFIX.length && [[mname substringToIndex:PREFIX.length] isEqualToString:PREFIX]) {
                //[self performSelector:method_getName(mlist[ii])];
                // Equivalent to the above, but doesn't produce an ARC warning
                objc_msgSend(self, method_getName(mlist[ii]));
            }
        }
        free(mlist);
    }
        
    [[BTEnum blocked] addObject:self];
}

@synthesize name=_name, ordinal=_ordinal;

@end

