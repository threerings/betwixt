//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTContext.h"

#import "BTObject.h"

#import "BTObject+Package.h"
#import "BTGeneration.h"
#import "BTGeneration+Package.h"

@implementation BTContext {
    NSMutableDictionary *_tokenToDispatcher;
    RAUnitSignal *_attached;
    RAUnitSignal *_detached;
    RAConnectionGroup *_conns;
}

- (id)init {
    if (!(self = [super init])) return nil;
    _children = [[NSMutableSet alloc] init];
    _tokenToDispatcher = [[NSMutableDictionary alloc] init];
    _attached = [[RAUnitSignal alloc] init];
    _detached = [[RAUnitSignal alloc] init];

    [self.detached connectUnit:^ {
        [_conns disconnectAll];
        // Copy the set before detaching as detaching modifies the set
        for (OOOBlockToken *token in [_tokenToDispatcher allKeys]) [self cancelListeningForToken:token];
    }];
    return self;
}

- (OOOBlockToken*)listenToDispatcher:(SPEventDispatcher *)dispatcher forEvent:(NSString *)eventType withBlock:(OOOBlockListener)block {
    OOOBlockToken *token = [dispatcher addEventListenerForType:eventType listener:block];
    [_tokenToDispatcher setObject:[NSValue valueWithNonretainedObject:dispatcher] forKey:token];
    return token;
}

- (void)cancelListeningForToken:(OOOBlockToken*)token {
    SPEventDispatcher *observee = [[_tokenToDispatcher objectForKey:token] nonretainedObjectValue];
    [observee removeListenerWithBlockToken:token];
    [_tokenToDispatcher removeObjectForKey:token];
}

- (void)addObject:(BTObject*)object {
    NSAssert(object->_parent == nil, @"Adding attached object");
    NSAssert(object->_children != nil, @"Adding detached object");
    NSAssert(_children != nil, @"Adding object to detached object");
    [_children addObject:object];
    object->_parent = self;
    [self.root attachObject:object];
}

- (void)removeObject:(BTObject*)object {
    NSAssert([_children member:object], @"Asked to remove unknown child");
    [_children removeObject:object];
    [object removeInternal];
}

- (void)detach {
    [NSException raise:NSInternalInconsistencyException
        format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (BTObject*)objectForName:(NSString*)name {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
        reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
        userInfo:nil];
}

- (BTGeneration*) root {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
        reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
        userInfo:nil];
}

@synthesize attached=_attached, detached=_detached, conns=_conns;

@end
