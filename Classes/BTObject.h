//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTNode.h"
#import "BTNodeContainer.h"

@interface BTObject : BTNode <BTNodeContainer> {
@package
    NSMutableSet* _children;
}

- (id)init;
- (BOOL)hasNodeNamed:(NSString*)name;

- (OOOBlockToken*)listenToDispatcher:(SPEventDispatcher*)dispatcher forEvent:(NSString*)eventType withBlock:(OOOBlockListener)block;
- (void)cancelListeningForToken:(OOOBlockToken*)token;

@end
