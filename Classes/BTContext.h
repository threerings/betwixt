//
//  Betwixt - Copyright 2011 Three Rings Design

#import "SPEventDispatcher.h"
#import "NSObject+BlockObservation.h"
#import "SPEventDispatcher+BlockListener.h"

@class BTObject;
@class BTGeneration;

@interface BTContext : SPEventDispatcher {
    @package
    NSMutableSet *_children;
}

- (AMBlockToken*)observeObject:(NSObject*)object forKeyPath:(NSString*)path withBlock:(AMBlockTask)block;
- (void)cancelObservationForToken:(AMBlockToken*)token;

- (OOOBlockToken*)listenToDispatcher:(SPEventDispatcher*)dispatcher forEvent:(NSString*)eventType withBlock:(OOOBlockListener)block;
- (void)cancelListeningForToken:(OOOBlockToken*)token;

- (void)addObject:(BTObject*)object;
- (BTObject*)objectForName:(NSString*)name;
- (void)removeObject:(BTObject*)object;

@property(nonatomic) BOOL added;
@property(nonatomic) BOOL removed;
@property(nonatomic,readonly) BTGeneration *root;

@end
