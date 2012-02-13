//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMode.h"
#import "BTModeStack.h"
#import "BTMode+Protected.h"
#import "BTMode+Package.h"
#import "BTSprite.h"
#import "BTNode+Protected.h"
#import "BTInput+Package.h"
#import "SPTouchProcessor.h"
#import "BTJugglerContainer.h"

@interface BTModeSprite : SPSprite<BTJugglerContainer> {
    SPJuggler* _juggler;
}
@end
@implementation BTModeSprite

- (id)initWithJuggler:(SPJuggler*)juggler {
    if (!(self = [super init])) {
        return nil;
    }
    _juggler = juggler;
    return self;
}

@synthesize juggler=_juggler;
@end
    

@interface BTNodeGroup : NSObject <NSFastEnumeration> {
@private
    BTMode* _mode;
    NSMutableArray* _group;
}
- (id)initWithMode:(BTMode*)mode;
- (void)addNode:(BTNode*)node;
- (void)removeNode:(BTNode*)node;
- (NSUInteger)count;
@end

@implementation BTNodeGroup
- (id)initWithMode:(BTMode *)mode {
    if (!(self = [super init])) {
        return nil;
    }
    _mode = mode;
    _group = [NSMutableArray array];
    return self;
}

- (void)addNode:(BTNode *)node {
    [_group addObject:node];
}

- (void)removeNode:(BTNode *)node {
    [_group removeObject:node];
}

- (NSUInteger)count {
    return _group.count;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state 
                                  objects:(__unsafe_unretained id [])buffer 
                                    count:(NSUInteger)len {
    if (state->state == 0) {
        state->extra[0] = _mode->_nextNodeId - 1;
        state->extra[1] = 0;
        state->extra[2] = 0;
        
        // mutationsPtr must not be null, so point it to an arbitrary unchanging value.
        state->mutationsPtr = &state->extra[0];
        // We can rewind our index, so we don't store it in state
        state->state = 1;
    }
    
    NSUInteger maxNodeId = state->extra[0];
    NSUInteger minNodeId = state->extra[1];
    NSUInteger index = state->extra[2];
    
    // Check to see if we need to rewind our index
    // (if nodes have been deleted during the iteration)
    if (_group.count > 0) {
        while (index > 0) {
            BTNode* prevNode = [_group objectAtIndex:index - 1];
            if (prevNode->_id >= minNodeId) {
                index--;
            } else {
                break;
            }
        }
    }

    // Since we're not limiting our batchCount to 1,
    // callers could end up enumerating over nodes that
    // are removed during enumeration. Do we care about this?
    NSUInteger batchCount = 0;
    while (batchCount < len && index < _group.count) {
        BTNode* node = [_group objectAtIndex:index++];
        NSUInteger nodeId = node->_id;
        // Ensure we haven't already returned this node, and that the
        // node hasn't been added since group enumeration started
        if (nodeId >= minNodeId && nodeId <= maxNodeId) {
            buffer[batchCount++] = node;
            minNodeId = nodeId + 1;
        }
    }
    
    state->extra[1] = minNodeId;
    state->extra[2] = index;
    state->itemsPtr = buffer;
    return batchCount;
}

@end

@interface BTRootNode : BTSprite {
@private
    __weak BTMode* _mode;
}
- (id)initWithMode:(BTMode*)mode;
- (BTMode*)mode;
@end

@implementation BTRootNode
- (id)initWithMode:(BTMode*)mode{
    if (!(self = [super initWithSprite:[[BTModeSprite alloc] initWithJuggler:mode->_juggler]])) {
        return nil;
    }
    _mode = mode;
    return self;
}
- (BTMode*)mode {
    return _mode;
}
- (BOOL)isAttached {
    return YES;
}
@end

@implementation BTMode

- (id)init {
    if (!(self = [super init])) return nil;
    _juggler = [[SPJuggler alloc] init];
    _rootNode = [[BTRootNode alloc] initWithMode:self];
    
    _input = [[BTInput alloc] initWithMode:self];
    _update = [[RAFloatSignal alloc] init];
    _entered = [[RAUnitSignal alloc] init];
    _exited = [[RAUnitSignal alloc] init];
    _conns = [[RAConnectionGroup alloc] init];
    _keyedObjects = [[NSMutableDictionary alloc] init];
    _groups = [[NSMutableDictionary alloc] init];
    
    return self;
}

- (BTNode*)nodeForKey:(NSString*) key {
    return [_keyedObjects objectForKey:key];
}

- (id<NSFastEnumeration>)nodesForGroup:(NSString*)group {
    return [_groups objectForKey:group];
}

- (int)countNodesInGroup:(NSString *)group {
    BTNodeGroup* nodeGroup = [_groups objectForKey:group];
    return [nodeGroup count];
}

- (BTMode*)mode {
    return self;
}

- (void)setup {
}

- (void)destroy {
}

- (void)update:(float)dt {
    [_juggler advanceTime:dt];
    [_update emitEvent:dt];
}

- (void)processTouches:(NSSet*)touches {
    [_input processTouches:touches];
}

- (void)enterInternal {
    [_entered emit];
}

- (void)exitInternal {
    [_exited emit];
}

- (void)setupInternal {
    [self setup];
}

- (void)shutdownInternal {
    [self destroy];
    _stack = nil;
    [_update disconnectAll];
    [_entered disconnectAll];
    [_exited disconnectAll];
    [_conns disconnectAll];
    [_rootNode cleanup];
    _rootNode = nil;
}

- (void)addKeys:(BTNode*)node {
    NSArray* keys = node.keys;
    if (keys != nil) {
        [node.detached connectUnit:^ {
            for (NSString* key in keys) {
                [_keyedObjects removeObjectForKey:key];
            }
        }];
        for (NSString* key in keys) {
            NSAssert1(![_keyedObjects objectForKey:key], @"Object key '%@' already used", key);
            [_keyedObjects setObject:node forKey:key];
        }
    }
}

- (void)addGroups:(BTNode*)node {
    NSArray* groups = node.groups;
    if (groups != nil) {
        [node.detached connectUnit:^ {
            for (NSString* group in groups) {
                BTNodeGroup* members = [_groups objectForKey:group];
                [members removeNode:node];
                if ([members count] == 0) [_groups removeObjectForKey:group];
            }
        }];
        for (NSString* group in groups) {
            BTNodeGroup* members = [_groups objectForKey:group];
            if (!members) {
                members = [[BTNodeGroup alloc] initWithMode:self];
                [_groups setObject:members forKey:group];
            }
            [members addNode:node];
        }
    }
}

- (SPSprite*)sprite {
    return _rootNode.sprite;
}

- (OOOBlockToken*)listenToDispatcher:(SPEventDispatcher*)dispatcher forEvent:(NSString*)eventType withBlock:(OOOBlockListener)block {
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

- (void)addNode:(BTNode*)node withName:(NSString*)name replaceExisting:(BOOL)replaceExisting {
    [_rootNode addNode:node withName:name replaceExisting:replaceExisting];
}

- (void)addNode:(BTDisplayObject*)node displayOn:(SPDisplayObjectContainer*)displayParent {
    [_rootNode addNode:node displayOn:displayParent];
}

- (void)removeNode:(BTNode*)object {
    [_rootNode removeNode:object];
}

- (BTNode*)nodeForName:(NSString*)name {
    return [_rootNode nodeForName:name];
}

@synthesize update=_update, entered=_entered, exited=_exited, stack=_stack, input=_input;

@end
