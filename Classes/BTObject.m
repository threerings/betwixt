//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTObject.h"

#import "BTUpdatable.h"
#import "BTObject.h"
#import "BTViewObject.h"

#import "BTNode+Package.h"
#import "BTNode+Protected.h"
#import "BTMode.h"
#import "BTMode+Package.h"
#import "BTMode+Protected.h"

@interface BTObject () {
@protected
    NSMutableDictionary* _namedObjects;
    NSMutableArray* _pendingChildren;
}
@property (nonatomic, readonly) NSMutableDictionary* namedObjects;
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

@implementation BTObject

- (id)init {
    if ((self = [super init])) {
        _children = [[NSMutableSet alloc] init];
    }
    return self;
}

- (NSMutableDictionary*)namedObjects {
    if (_namedObjects == nil) _namedObjects = [[NSMutableDictionary alloc] init];
    return _namedObjects;
}

- (NSMutableArray*)pendingChildren {
    if (_pendingChildren == nil) _pendingChildren = [NSMutableArray array];
    return _pendingChildren;
}

- (void)associateNode:(BTNode*)node withName:(NSString*)name {
    NSAssert(![self.namedObjects objectForKey:name], @"Object name '%@' already used", name);
    [node.removed connectUnit:^{ [self.namedObjects removeObjectForKey:name]; }];
    [self.namedObjects setObject:node forKey:name];
}

- (void)addNodeInternal:(BTNode*)node withName:(NSString*)name 
        replaceExisting:(BOOL)replaceExisting parent:(SPDisplayObjectContainer*)parent {
    
    NSAssert(!_wasRemoved, @"Adding object to removed object");
    NSAssert(!node.isLive, @"Cannot add an already-added object");
    NSAssert(!node->_wasRemoved, @"Cannot re-add a removed object");
    
    // If we're not yet attached to the mode, we'll attach this node when we are
    if (!self.isLive) {
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
    
    // Does the object have a name?
    if (name != nil) {
        if (replaceExisting) {
            [[self nodeForName:name] removeSelf];
        }
        [self associateNode:node withName:name];
    }
    
    // Does the object have a display parent?
    if (parent != nil) {
        [parent addChild:((BTViewObject *)node).display];
    }
    
    // Register the node with the mode
    [self.mode registerNode:node];
    
    // Tell the node it's attached
    [node addedInternal];
}

- (void)addedInternal {
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
    [super addedInternal];
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

- (void)addNode:(BTViewObject*)node displayOn:(SPDisplayObjectContainer*)displayParent {
    [self addNodeInternal:node withName:nil replaceExisting:NO parent:displayParent];
}

- (void)removeNode:(BTNode*)node {
    NSAssert(node->_parent == self || node->_parent == nil, @"node doesn't belong to us");
    
    // if _children is nil, we're in the middle of being removed ourselves.
    if (node->_parent == nil || _children == nil) {
        return;
    }
    
    NSAssert([_children containsObject:node], @"node not in _children");
    [_children removeObject:node];
    [node removedInternal];
}

- (void)removeNodeNamed:(NSString*)name {
    BTNode* node = [self nodeForName:name];
    if (node != nil) {
        [self removeNode:node];
    }
}

- (BTNode*)nodeForName:(NSString*)name {
    return [self.namedObjects objectForKey:name];
}

- (BOOL)hasNodeNamed:(NSString*)name {
    return [self nodeForName:name] != nil;
}

- (void)removedInternal {
    // nil out parent immediately - so that we're not considered "live"
    // while children are being removed - rather than waiting for
    // BTNode.removedInternal to do it at the end of the function
    _parent = nil;

    // Prevent our _children array from being manipulated while
    // we're iterating it
    NSMutableSet* kids = _children;
    _children = nil;
    for (BTObject* child in kids) {
        [child removedInternal];
    }
    _children = kids;
    [super removedInternal];
}

- (void)cleanupInternal {
    NSMutableSet* kids = _children;
    _children = nil;
    for (BTObject* child in kids) {
        [child cleanupInternal];
    }
    [super cleanupInternal];
}

@end
