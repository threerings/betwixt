//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTNode.h"
#import "BTNodeContainer.h"

@interface BTObject : BTNode<BTNodeContainer> {
@package
    NSMutableSet *_children;
}

- (id)init;
- (void)addNode:(BTNode*)node;
- (void)addNode:(BTNode*)node withName:(NSString*)name;
- (void)addNode:(BTNode *)node withName:(NSString *)name replaceExisting:(BOOL)replaceExisting;
- (BTNode*)nodeForName:(NSString*)name;
- (void)removeNode:(BTNode*)node;

- (OOOBlockToken*)listenToDispatcher:(SPEventDispatcher*)dispatcher forEvent:(NSString*)eventType withBlock:(OOOBlockListener)block;
- (void)cancelListeningForToken:(OOOBlockToken*)token;

@end
