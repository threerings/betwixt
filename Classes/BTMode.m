//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMode.h"
#import "BTInput.h"
#import "BTModeStack.h"
#import "BTMode+Protected.h"
#import "BTMode+Package.h"
#import "BTSpriteObject.h"
#import "BTNode+Protected.h"
#import "BTNode+Package.h"
#import "SPTouchProcessor.h"
#import "BTJugglerContainer.h"
#import "BTUpdatable.h"

@interface BTModeSprite : SPSprite<BTJugglerContainer> {
@private
    SPJuggler* _juggler;
}
@end

@implementation BTModeSprite

@synthesize juggler = _juggler;

- (id)initWithJuggler:(SPJuggler*)juggler {
    if ((self = [super init])) {
        _juggler = juggler;
    }
    return self;
}
@end

@interface BTNodeGroup : NSObject <NSFastEnumeration> {
@private
    BTMode* _mode;
    NSMutableArray* _group;
}

@property (nonatomic,readonly) NSUInteger count;

- (id)initWithMode:(BTMode*)mode;
- (void)addNode:(BTNode*)node;
- (void)removeNode:(BTNode*)node;
@end

@implementation BTNodeGroup

- (id)initWithMode:(BTMode *)mode {
    if ((self = [super init])) {
        _mode = mode;
        _group = [NSMutableArray array];
    }
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

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState*)state
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
        index = MIN(index, _group.count - 1);
        while (index > 0) {
            BTNode* prevNode = _group[index - 1];
            if (prevNode->_id >= minNodeId) {
                index--;
            } else {
                break;
            }
        }
    }

    NSUInteger batchCount = 0;
    // Limit our batchCount to 1, so that enumerators
    // are guaranteed not to see nodes that have been removed.
    // This is slightly slower, but more correct than just returning
    // 'len' items, some of which may no longer be valid when the
    // iteration reaches them.
    while (batchCount < 1 && index < _group.count) {
    //while (batchCount < len && index < _group.count) {
        BTNode* node = _group[index++];
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

@interface BTRootNode : BTSpriteObject {
@private
    __weak BTMode* _mode;
}
- (id)initWithMode:(BTMode*)mode;
- (BTMode*)mode;
@end

@implementation BTRootNode
- (id)initWithMode:(BTMode*)mode{
    if ((self = [super initWithSprite:[[BTModeSprite alloc] initWithJuggler:mode->_juggler]])) {
        _mode = mode;
    }
    return self;
}
- (BTMode*)mode {
    return _mode;
}
- (BOOL)isLive {
    return YES;
}
@end

@implementation BTMode

@synthesize update = _update;
@synthesize entered = _entered;
@synthesize exited = _exited;
@synthesize input = _input;
@synthesize runningTime = _runningTime;
@synthesize isLive = _isLive;

- (id)init {
    if ((self = [super init])) {
        _juggler = [[SPJuggler alloc] init];
        _rootNode = [[BTRootNode alloc] initWithMode:self];

        _input = [[BTInput alloc] initWithRoot:_rootNode.sprite];
        _update = [[RAFloatSignal alloc] init];
        _entered = [[RAUnitSignal alloc] init];
        _exited = [[RAUnitSignal alloc] init];
        _conns = [[RAConnectionGroup alloc] init];
        _keyedObjects = [[NSMutableDictionary alloc] init];
        _groups = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (BTNode*)nodeForKey:(NSString*)key {
    return _keyedObjects[key];
}

- (id<NSFastEnumeration>)nodesInGroup:(NSString*)group {
    return _groups[group];
}

- (int)countNodesInGroup:(NSString*)group {
    BTNodeGroup* nodeGroup = _groups[group];
    return nodeGroup.count;
}

- (BTMode*)mode {
    return self;
}

- (void)setup {
}

- (void)destroy {
}

- (void)update:(float)dt {
    _runningTime += dt;
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
    _isLive = YES;
    [self setup];
}

- (void)shutdownInternal {
    [self destroy];
    _isLive = NO;
    _modeStack = nil;
    [_update disconnectAll];
    [_entered disconnectAll];
    [_exited disconnectAll];
    [_conns disconnectAll];
    [_rootNode cleanupInternal];
    _rootNode = nil;
    _input = nil;
}

- (void)registerNode:(BTNode*)node {
    node->_id = _nextNodeId++;

    // If the object is BTUpdatable, wire up its update function to the update event
    if ([node conformsToProtocol:@protocol(BTUpdatable)]) {
        BTNode<BTUpdatable>* updatable = (BTNode<BTUpdatable>*)node;
        [updatable.conns onFloatReactor:self.update connectSlot:^(float dt) {
            [updatable update:dt];
        }];
    }

    // register keys
    NSArray* keys = node.keys;
    if (keys != nil) {
        [node.removed connectUnit:^ {
            for (NSString* key in keys) {
                [_keyedObjects removeObjectForKey:key];
            }
        }];
        for (NSString* key in keys) {
            NSAssert(!_keyedObjects[key], @"Object key '%@' already used", key);
            _keyedObjects[key] = node;
        }
    }

    // register groups
    NSArray* groups = node.groups;
    if (groups != nil) {
        [node.removed connectUnit:^ {
            for (NSString* group in groups) {
                BTNodeGroup* members = _groups[group];
                [members removeNode:node];
                if ([members count] == 0) [_groups removeObjectForKey:group];
            }
        }];
        for (NSString* group in groups) {
            BTNodeGroup* members = _groups[group];
            if (!members) {
                members = [[BTNodeGroup alloc] initWithMode:self];
                _groups[group] = members;
            }
            [members addNode:node];
        }
    }
}

- (SPSprite*)sprite {
    return _rootNode.sprite;
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

- (void)addNode:(BTViewObject*)node displayOn:(SPDisplayObjectContainer*)displayParent {
    [_rootNode addNode:node displayOn:displayParent];
}

- (void)removeNode:(BTNode*)object {
    [_rootNode removeNode:object];
}

- (BTNode*)nodeForName:(NSString*)name {
    return [_rootNode nodeForName:name];
}

- (BTModeStack*)modeStack {
    return _modeStack;
}

@end
