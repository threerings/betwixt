//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTContext.h"

#import "BTObject.h"

#import "BTNode+Package.h"
#import "BTGeneration.h"
#import "BTGeneration+Package.h"

@implementation BTContext {
    NSMutableDictionary *_tokenToDispatcher;
}

- (id)init {
    if (!(self = [super init])) return nil;
    _children = [[NSMutableSet alloc] init];
    _tokenToDispatcher = [[NSMutableDictionary alloc] init];

    [self.detached connectUnit:^ {
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

- (void)addNode:(BTNode*)object {
    NSAssert(object->_parent == nil, @"Adding attached object");
    NSAssert(_children != nil, @"Adding object to detached object");
    [_children addObject:object];
    object->_parent = self;
    [self.root attachNode:object];
}

- (void)removeNode:(BTNode*)object {
    if (![_children member:object]) return;
    [_children removeObject:object];
    [object removeInternal];
}

- (BTNode*)nodeForName:(NSString*)name {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
        reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
        userInfo:nil];
}

@end
