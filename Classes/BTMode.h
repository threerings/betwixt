//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObjectContainer.h"

@class BTModeStack;
@class SPSprite;

@interface BTMode : BTDisplayObjectContainer {
@package
    __weak BTModeStack *_stack;
}

- (BTNode*)nodeForKey:(NSString*)key;
/// Returns the nodes in the group or nil if there are no nodes in the group.
- (NSArray*)nodesForGroup:(NSString*)group;

@property(nonatomic,readonly) RAFloatSignal *update;
@property(nonatomic,readonly) RAUnitSignal *entered;
@property(nonatomic,readonly) RAUnitSignal *exited;
@property(nonatomic,readonly) BTModeStack *stack;
@property(nonatomic,readonly) SPSprite *sprite;

@end
