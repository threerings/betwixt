//
// gulp - Copyright 2011 Three Rings Design

#import "GUResourceManager.h"
#import "GUResourceFactory.h"
#import "GUResource.h"

@implementation GUResourceManager

+ (GUResourceManager *)sharedManager {
    static GUResourceManager *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[GUResourceManager alloc] init];
        }
    }
    return instance;
}

- (id)init {
    if (!(self = [super init])) {
        return nil;
    }
    _factories = [[NSMutableDictionary alloc] init];
    _resources = [[NSMutableDictionary alloc] init];
    return self;
}

- (GUResource *)getResource:(NSString *)name {
    return [_resources objectForKey:name];
}

- (GUResource *)requireResource:(NSString *)name {
    GUResource *rsrc = [self getResource:name];
    NSAssert(rsrc != nil, @"No such resource: %@", name);
    return rsrc;
}

- (BOOL)isLoaded:(NSString *)name {
    return [self getResource:name] != nil;
}

- (void)unloadGroup:(NSString *)group {
    for (GUResource *rsrc in [_resources allValues]) {
        if ([rsrc.group isEqualToString:group]) {
            [_resources removeObjectForKey:rsrc.name];
        }
    }
}

- (void)unloadAll {
    [_resources removeAllObjects];
}

- (void)registerType:(NSString *)type toFactory:(id<GUResourceFactory>)factory {
    [_factories setObject:factory forKey:type];
}

- (id<GUResourceFactory>)getFactory:(NSString *)type {
    return [_factories objectForKey:type];
}

- (void)add:(GUResource *)rsrc {
    NSAssert(rsrc.group != nil, @"Resource doesn't belong to a group: %@", rsrc);
    NSAssert(rsrc.state == LS_LOADED, @"Resource isn't loaded: %@", rsrc);
    NSAssert([self getResource:rsrc.name] == nil, 
             @"A Resource with that name already exists [name=%@]", [rsrc name]);
    [_resources setObject:rsrc forKey:rsrc.name];
}

@end
