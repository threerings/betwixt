//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTGeneration.h"
#import "BTGeneration+Package.h"
#import "BTObject+Package.h"

@implementation BTGeneration

- (id)init {
    if (!(self = [super init])) return nil;
    _children = [[NSMutableSet alloc] init];
    _namedObjects = [NSMutableDictionary dictionary];
    return self;
}

- (BTObject*)objectForName:(NSString*)name {
    return [_namedObjects objectForKey:name];
}

- (BTGeneration*) root {
    return self;
}


@end

@implementation BTGeneration (package)

- (void)enterFrame:(SPEnterFrameEvent*)ev {
    [self dispatchEvent:ev];
}

- (void)attachObject:(BTObject*)object {
    for (NSString *name in object.names) {
        NSAssert1(![_namedObjects objectForKey:name], @"Object name '%@' already used", name);
        [_namedObjects setObject:object forKey:name];
    }
    object.added = YES;
}

@end
