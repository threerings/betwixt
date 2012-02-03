//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMode.h"
#import "BTModeStack.h"
#import "BTKeyed.h"
#import "BTMode+Protected.h"
#import "BTMode+Package.h"
#import "BTSprite.h"
#import "BTNode+Protected.h"

@interface BTRootNode : BTSprite {
@private
    __weak BTMode *_mode;
}
- (id)initWithMode:(BTMode *)mode;
- (BTMode *)mode;
@end

@implementation BTRootNode
- (id)initWithMode:(BTMode *)mode {
    if (!(self = [super init])) {
        return nil;
    }
    _mode = mode;
    return self;
}
- (BTMode *)mode {
    return _mode;
}
@end

@implementation BTMode {
    RAFloatSignal *_update;
    RAUnitSignal *_entered;
    RAUnitSignal *_exited;
    BTRootNode *_rootNode;
    NSMutableDictionary *_keyedObjects;
    NSMutableDictionary *_groups;
}

- (id)init {
    if (!(self = [super init])) return nil;
    _rootNode = [[BTRootNode alloc] initWithMode:self];
    _rootNode.sprite.touchable = NO;
    
    _update = [[RAFloatSignal alloc] init];
    _entered = [[RAUnitSignal alloc] init];
    _exited = [[RAUnitSignal alloc] init];
    _keyedObjects = [[NSMutableDictionary alloc] init];
    _groups = [[NSMutableDictionary alloc] init];
    
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

- (SPDisplayObjectContainer *)container {
    return _rootNode.container;
}

- (void)update:(float)dt {
    [_update emitEvent:dt];
}

- (void)enterInternal {
    _rootNode.sprite.touchable = YES;
    [_entered emit];
}

- (void)exitInternal {
    _rootNode.sprite.touchable = NO;
    [_exited emit];
}

- (void)shutdownInternal {
    _stack = nil;
    [_rootNode cleanup];
    _rootNode = nil;
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

- (SPSprite *)sprite {
    return _rootNode.sprite;
}

- (OOOBlockToken*)listenToDispatcher:(SPEventDispatcher *)dispatcher forEvent:(NSString *)eventType withBlock:(OOOBlockListener)block {
    return [_rootNode listenToDispatcher:dispatcher forEvent:eventType withBlock:block];
}

- (void)cancelListeningForToken:(OOOBlockToken*)token {
    [_rootNode cancelListeningForToken:token];
}

- (void)addNode:(BTNode*)object {
    [_rootNode addNode:object];
}

- (void)addNode:(BTNode*)object withName:(NSString*)name {
    [_rootNode addNode:object withName:name];
}

- (void)replaceNode:(BTNode*)object withName:(NSString*)name {
    [_rootNode replaceNode:object withName:name];
}

- (void)removeNode:(BTNode*)object {
    [_rootNode removeNode:object];
}

- (BTNode*)nodeForName:(NSString*)name {
    return [_rootNode nodeForName:name];
}

- (void)addAndDisplayNode:(BTDisplayObject *)node {
    [_rootNode addAndDisplayNode:node];
}

@synthesize update=_update, entered=_entered, exited=_exited, stack=_stack;

@end
