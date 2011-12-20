//
//  Betwixt - Copyright 2011 Three Rings Design

#import "SPEventDispatcher+BlockListener.h"
#import "BTNode.h"

@interface BTContext : BTNode {
    @package
        NSMutableSet *_children;
}

- (OOOBlockToken*)listenToDispatcher:(SPEventDispatcher*)dispatcher forEvent:(NSString*)eventType withBlock:(OOOBlockListener)block;
- (void)cancelListeningForToken:(OOOBlockToken*)token;

- (void)addNode:(BTNode*)node;
- (BTNode*)nodeForName:(NSString*)name;
- (void)removeNode:(BTNode*)node;

@end
