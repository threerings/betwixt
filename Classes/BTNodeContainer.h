//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPEventDispatcher+BlockListener.h"

@class BTNode;
@class BTMode;

@protocol BTNodeContainer

- (BTMode *)mode;
- (void)addNode:(BTNode *)node;
- (void)addNode:(BTNode *)node withName:(NSString *)name;
- (void)addNode:(BTNode *)node withName:(NSString *)name replaceExisting:(BOOL)replaceExisting;
- (BTNode*)nodeForName:(NSString *)name;
- (void)removeNode:(BTNode *)node;

- (OOOBlockToken*)listenToDispatcher:(SPEventDispatcher*)dispatcher forEvent:(NSString*)eventType withBlock:(OOOBlockListener)block;
- (void)cancelListeningForToken:(OOOBlockToken*)token;

@end
