//
//  Betwixt - Copyright 2011 Three Rings Design

#import "SPEventDispatcher.h"
#import "RAUnitSignal.h"
#import "RAConnectionGroup.h"
#import "SPEventDispatcher+BlockListener.h"

@class BTObject;
@class BTGeneration;

@interface BTContext : NSObject {
    @package
        NSMutableSet *_children;
}

- (void)detach;

- (OOOBlockToken*)listenToDispatcher:(SPEventDispatcher*)dispatcher forEvent:(NSString*)eventType withBlock:(OOOBlockListener)block;
- (void)cancelListeningForToken:(OOOBlockToken*)token;

- (void)addObject:(BTObject*)object;
- (BTObject*)objectForName:(NSString*)name;
- (void)removeObject:(BTObject*)object;

@property(nonatomic,readonly) RAUnitSignal *attached;
@property(nonatomic,readonly) RAUnitSignal *detached;
@property(nonatomic,readonly) BTGeneration *root;
@property(nonatomic,readonly) RAConnectionGroup *conns;

@end
