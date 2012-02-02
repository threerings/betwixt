//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTObject.h"

#import "BTGrouped.h"
#import "BTKeyed.h"
#import "BTUpdatable.h"
#import "BTObject.h"

#import "BTNode+Package.h"
#import "BTNode+Protected.h"
#import "BTMode.h"
#import "BTMode+Package.h"

@interface BTObject ()
@property (nonatomic, readonly) NSMutableDictionary *namedObjects;
@property (nonatomic, readonly) NSMutableDictionary *tokenDispatchers;
@end

@implementation BTObject {
    NSMutableDictionary *_tokenDispatchers;
    NSMutableDictionary *_namedObjects;
}

- (id)init {
    if (!(self = [super init])) return nil;
    _children = [[NSMutableSet alloc] init];
    
    [self.detached connectUnit:^ {
        // Copy the set before detaching as detaching modifies the set
        // Go through _tokenDispatchers instead of tokenDispatchers to keep from instantiating it
        // if there aren't any listeners
        for (OOOBlockToken *token in [_tokenDispatchers allKeys]) {
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

- (OOOBlockToken*)listenToDispatcher:(SPEventDispatcher *)dispatcher forEvent:(NSString *)eventType withBlock:(OOOBlockListener)block {
    OOOBlockToken *token = [dispatcher addEventListenerForType:eventType listener:block];
    [self.tokenDispatchers setObject:[NSValue valueWithNonretainedObject:dispatcher] forKey:token];
    return token;
}

- (void)cancelListeningForToken:(OOOBlockToken*)token {
    SPEventDispatcher *observee = [[self.tokenDispatchers objectForKey:token] nonretainedObjectValue];
    [observee removeListenerWithBlockToken:token];
    [self.tokenDispatchers removeObjectForKey:token];
}

- (void)associateNode:(BTNode*)node withName:(NSString*)name {
    NSAssert1(![self.namedObjects objectForKey:name], @"Object name '%@' already used", name);
    [node.detached connectUnit:^{ [self.namedObjects removeObjectForKey:name]; }];
    [self.namedObjects setObject:node forKey:name];
}

- (void)addNode:(BTNode*)object {
    NSAssert(object->_parent == nil, @"Adding attached object");
    NSAssert(_children != nil, @"Adding object to detached object");
    [_children addObject:object];
    object->_parent = self;
    if ([object conformsToProtocol:@protocol(BTKeyed)]) {
        [self.mode addKeys:(BTNode<BTKeyed>*)object];
    }
    if ([object conformsToProtocol:@protocol(BTGrouped)]) {
        [self.mode addGroups:(BTNode<BTGrouped>*)object];
    }
    [object.attached emit];
    
    // If the object is BTUpdatable, wire up its update function to the update event
    if ([object conformsToProtocol:@protocol(BTUpdatable)]) {
        __weak BTNode<BTUpdatable>* obj = (BTNode<BTUpdatable>*)object;
        [object.conns addConnection:[self.mode.update connectSlot:^(float dt) {
            [obj update:dt];
        }]];
    }
}

- (void)addNode:(BTNode*)object withName:(NSString*)name {
    [self associateNode:object withName:name];
    [self addNode:object];
}

- (void)replaceNode:(BTNode*)object withName:(NSString*)name {
    [[self nodeForName:name] detach];
    [self addNode:object withName:name];
}

- (void)removeNode:(BTNode*)object {
    if (![_children member:object]) return;
    [_children removeObject:object];
    [object removeInternal];
}

- (BTNode*)nodeForName:(NSString*)name {
    return [self.namedObjects objectForKey:name];
}

- (void)removeInternal {
    // Prevent our _children array from being manipulated while
    // we're iterating it
    NSMutableSet *kids = _children;
    _children = nil;
    for (BTObject *child in kids) {
        [child removeInternal];
    }
    _children = kids;
    [super removeInternal];
}

- (void)cleanup {
    NSMutableSet *kids = _children;
    _children = nil;
    for (BTObject *child in kids) {
        [child cleanup];
    }
    [super cleanup];
}

@end
