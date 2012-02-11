//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTObject.h"

#import "BTUpdatable.h"
#import "BTObject.h"
#import "BTDisplayObject.h"

#import "BTNode+Package.h"
#import "BTNode+Protected.h"
#import "BTMode.h"
#import "BTMode+Package.h"

@interface BTObject ()
@property (nonatomic, readonly) NSMutableDictionary* namedObjects;
@property (nonatomic, readonly) NSMutableDictionary* tokenDispatchers;
@end

@interface BTPendingChildNode : NSObject {
@public
    BTNode *node;
    NSString *name;
    BOOL replaceExisting;
    SPDisplayObjectContainer *displayParent;
}
@end
@implementation BTPendingChildNode @end

@implementation BTObject {
    NSMutableDictionary* _tokenDispatchers;
    NSMutableDictionary* _namedObjects;
    NSMutableArray* _pendingChildren;
}

- (id)init {
    if (!(self = [super init])) return nil;
    _children = [[NSMutableSet alloc] init];
    
    [self.detached connectUnit:^ {
        // Copy the set before detaching as detaching modifies the set
        // Go through _tokenDispatchers instead of tokenDispatchers to keep from instantiating it
        // if there aren't any listeners
        for (OOOBlockToken* token in [_tokenDispatchers allKeys]) {
            [self cancelListeningForToken:token];
        }
    }];
    return self;
}

- (NSMutableDictionary*)tokenDispatchers {
    if (_tokenDispatchers == nil) _tokenDispatchers = [[NSMutableDictionary alloc] init];
    return _tokenDispatchers;
}

- (NSMutableDictionary*)namedObjects {
    if (_namedObjects == nil) _namedObjects = [[NSMutableDictionary alloc] init];
    return _namedObjects;
}

- (NSMutableArray*)pendingChildren {
    if (_pendingChildren == nil) _pendingChildren = [NSMutableArray array];
    return _pendingChildren;
}

- (OOOBlockToken*)listenToDispatcher:(SPEventDispatcher*)dispatcher forEvent:(NSString*)eventType withBlock:(OOOBlockListener)block {
    OOOBlockToken* token = [dispatcher addEventListenerForType:eventType listener:block];
    [self.tokenDispatchers setObject:[NSValue valueWithNonretainedObject:dispatcher] forKey:token];
    return token;
}

- (void)cancelListeningForToken:(OOOBlockToken*)token {
    SPEventDispatcher* observee = [[self.tokenDispatchers objectForKey:token] nonretainedObjectValue];
    [observee removeListenerWithBlockToken:token];
    [self.tokenDispatchers removeObjectForKey:token];
}

- (void)associateNode:(BTNode*)node withName:(NSString*)name {
    NSAssert(![self.namedObjects objectForKey:name], @"Object name '%@' already used", name);
    [node.detached connectUnit:^{ [self.namedObjects removeObjectForKey:name]; }];
    [self.namedObjects setObject:node forKey:name];
}

- (void)addNodeInternal:(BTNode*)node withName:(NSString*)name 
        replaceExisting:(BOOL)replaceExisting parent:(SPDisplayObjectContainer*)parent {
    
    NSAssert(!self.isDetached, @"Adding object to detached object");
    NSAssert(!node.isAttached, @"Cannot add an already-attached object");
    NSAssert(!node.isDetached, @"Cannot re-add a detached object");
    
    // If we're not yet attached to the mode, we'll attach this node when we are
    if (!self.isAttached) {
        BTPendingChildNode *pendingChild = [[BTPendingChildNode alloc] init];
        pendingChild->node = node;
        pendingChild->name = name;
        pendingChild->replaceExisting = replaceExisting;
        pendingChild->displayParent = parent;
        [self.pendingChildren addObject:pendingChild];
        return;
    }
    
    [_children addObject:node];
    node->_parent = self;
    
    BTMode *mode = self.mode;
    [mode addKeys:node];
    [mode addGroups:node];
    
    // If the object is BTUpdatable, wire up its update function to the update event
    if ([node conformsToProtocol:@protocol(BTUpdatable)]) {
        __weak BTNode<BTUpdatable>* obj = (BTNode<BTUpdatable>*)node;
        [node.conns addConnection:[self.mode.update connectSlot:^(float dt) {
            [obj update:dt];
        }]];
    }
    
    // Does the object have a name?
    if (name != nil) {
        if (replaceExisting) {
            [[self nodeForName:name] detach];
        }
        [self associateNode:node withName:name];
    }
    
    // Does the object have a display parent?
    if (parent != nil) {
        [parent addChild:((BTDisplayObject *)node).display];
    }
    
    // Tell the node it's attached
    [node attachedInternal];
}

- (void)attachedInternal {
    if (_pendingChildren != nil) {
        // Attach all our pending children
        for (BTPendingChildNode *pending in _pendingChildren) {
            [self addNodeInternal:pending->node 
                         withName:pending->name 
                  replaceExisting:pending->replaceExisting 
                           parent:pending->displayParent];
        }
        _pendingChildren = nil;
    }
    [super attachedInternal];
}

- (void)addNode:(BTNode*)node {
    [self addNodeInternal:node withName:nil replaceExisting:NO parent:nil];
}

- (void)addNode:(BTNode*)node withName:(NSString*)name {
    [self addNodeInternal:node withName:name replaceExisting:NO parent:nil];
}

- (void)addNode:(BTNode*)node withName:(NSString*)name replaceExisting:(BOOL)replaceExisting {
    [self addNodeInternal:node withName:name replaceExisting:replaceExisting parent:nil];
}

- (void)addNode:(BTDisplayObject*)node displayOn:(SPDisplayObjectContainer*)displayParent {
    [self addNodeInternal:node withName:nil replaceExisting:NO parent:displayParent];
}

- (void)removeNode:(BTNode*)node {
    if (![_children member:node]) return;
    [_children removeObject:node];
    [node removeInternal];
}

- (BTNode*)nodeForName:(NSString*)name {
    return [self.namedObjects objectForKey:name];
}

- (void)removeInternal {
    // Prevent our _children array from being manipulated while
    // we're iterating it
    NSMutableSet* kids = _children;
    _children = nil;
    for (BTObject* child in kids) {
        [child removeInternal];
    }
    _children = kids;
    [super removeInternal];
}

- (void)cleanup {
    NSMutableSet* kids = _children;
    _children = nil;
    for (BTObject* child in kids) {
        [child cleanup];
    }
    [super cleanup];
}

@end
