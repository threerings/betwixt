//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMode.h"
#import "BTModeStack.h"
#import "BTKeyed.h"
#import "BTMode+Protected.h"
#import "BTMode+Package.h"

@implementation BTMode {
    RAFloatSignal *_update;
    RAUnitSignal *_entered;
    RAUnitSignal *_exited;
    SPSprite *_sprite;
    NSMutableDictionary *_keyedObjects;
    NSMutableDictionary *_groups;
}

- (id)init {
    if (!(self = [super init])) return nil;
    _sprite = [[SPSprite alloc] init];
    _update = [[RAFloatSignal alloc] init];
    _entered = [[RAUnitSignal alloc] init];
    _exited = [[RAUnitSignal alloc] init];
    _keyedObjects = [[NSMutableDictionary alloc] init];
    _groups = [[NSMutableDictionary alloc] init];
    
    _sprite.touchable = NO;
    
    return self;
}

- (BTNode*)nodeForKey:(NSString*) key {
    return [_keyedObjects objectForKey:key];
}

- (NSArray*)nodesForGroup:(NSString*)group {
    return [_groups objectForKey:group];
}

- (BTMode*)mode {
    return self;
}

- (void)detach {
    [_stack popMode];
}

- (SPDisplayObjectContainer *)container {
    return _sprite;
}

- (void)update:(float)dt {
    [_update emitEvent:dt];
}

- (void)enter {
    _sprite.touchable = YES;
    [_entered emit];
}

- (void)exit {
    _sprite.touchable = NO;
    [_exited emit];
}

- (void)addKeys:(BTNode<BTKeyed>*)node {
    NSArray *keys = ((id<BTKeyed>)node).keys;
    [node.detached connectUnit:^ {
        for (NSString *key in keys) {
            [_keyedObjects removeObjectForKey:key];
        }
    }];
    for (NSString *key in keys) {
        NSAssert1(![_keyedObjects objectForKey:key], @"Object key '%@' already used", key);
        [_keyedObjects setObject:node forKey:key];
    }
}

- (void)addGroups:(BTNode<BTGrouped>*)node {
    NSArray *groups = ((id<BTGrouped>)node).groups;
    [node.detached connectUnit:^ {
        for (NSString *group in groups) {
            NSMutableArray *members = [_groups objectForKey:group];
            [members removeObject:node];
            if ([members count] == 0) [_groups removeObjectForKey:group];
        }
    }];
    for (NSString *group in groups) {
        NSMutableArray *members = [_groups objectForKey:group];
        if (!members) {
            members = [[NSMutableArray alloc] init];
            [_groups setObject:members forKey:group];
        }
        [members addObject:node];
    }
}

@synthesize sprite=_sprite, update=_update, entered=_entered, exited=_exited, stack=_stack;

@end
