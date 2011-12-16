//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTGeneration.h"
#import "BTGeneration+Package.h"
#import "BTObject+Package.h"

@implementation BTGeneration {
    RAUnitSignal *_enterFrame;
}

- (id)init {
    if (!(self = [super init])) return nil;
    _children = [[NSMutableSet alloc] init];
    _namedObjects = [NSMutableDictionary dictionary];
    _enterFrame = [[RAUnitSignal alloc] init];
    return self;
}

- (BTObject*)objectForName:(NSString*)name {
    return [_namedObjects objectForKey:name];
}

- (BTGeneration*) root {
    return self;
}

@synthesize enterFrame=_enterFrame;

@end

@implementation BTGeneration (package)

- (void)enterFrame:(SPEnterFrameEvent*)ev {
    [_enterFrame emit];
}

- (void)attachObject:(BTObject*)object {
    for (NSString *name in object.names) {
        NSAssert1(![_namedObjects objectForKey:name], @"Object name '%@' already used", name);
        [_namedObjects setObject:object forKey:name];
    }
    [object.attached emit];
}

@end
