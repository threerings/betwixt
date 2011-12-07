//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTContext.h"

@implementation BTContext {
    NSMutableDictionary *_tokenToObserver;
    NSMutableDictionary *_tokenToDispatcher;
}

- (id)init {
    if (!(self = [super init])) return nil;
    _tokenToObserver = [[NSMutableDictionary alloc] init];
    _tokenToDispatcher = [[NSMutableDictionary alloc] init];

    OBSERVE(self, self, @"removed", {
        // Copy the set before detaching as detaching modifies the set
        for (AMBlockToken *token in [_tokenToObserver allKeys]) [self cancelObservationForToken:token];
        for (OOOBlockToken *token in [_tokenToDispatcher allKeys]) [self cancelListeningForToken:token];
    });
    return self;
}

- (AMBlockToken*)observeObject:(NSObject *)object forKeyPath:(NSString *)path withBlock:(AMBlockTask)block {
    AMBlockToken *token = [object addObserverForKeyPath:path task:block];
    [_tokenToObserver setObject:[NSValue valueWithNonretainedObject:object] forKey:token];
    return token;
    }

- (OOOBlockToken*)listenToDispatcher:(SPEventDispatcher *)dispatcher forEvent:(NSString *)eventType withBlock:(OOOBlockListener)block {
    OOOBlockToken *token = [dispatcher addEventListenerForType:eventType listener:block];
    [_tokenToDispatcher setObject:[NSValue valueWithNonretainedObject:dispatcher] forKey:token];
    return token;
}

- (void)cancelObservationForToken:(AMBlockToken*)token {
    NSObject *observee = [[_tokenToObserver objectForKey:token] nonretainedObjectValue];
    [observee removeObserverWithBlockToken:token];
    [_tokenToObserver removeObjectForKey:token];
}

- (void)cancelListeningForToken:(OOOBlockToken*)token {
    SPEventDispatcher *observee = [[_tokenToDispatcher objectForKey:token] nonretainedObjectValue];
    [observee removeListenerWithBlockToken:token];
    [_tokenToDispatcher removeObjectForKey:token];
}

@synthesize added, removed;

@end
