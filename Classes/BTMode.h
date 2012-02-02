//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayNodeContainer.h"

@class BTModeStack;
@class SPSprite;

@interface BTMode : NSObject<BTDisplayNodeContainer> {
@package
    __weak BTModeStack *_stack;
}

- (BTNode*)nodeForKey:(NSString*)key;
/// Returns the nodes in the group or nil if there are no nodes in the group.
- (NSArray*)nodesForGroup:(NSString*)group;

- (void)addNode:(BTNode*)node;
- (void)addNode:(BTNode*)node withName:(NSString*)name;
- (void)replaceNode:(BTNode*)node withName:(NSString*)name;
- (BTNode*)nodeForName:(NSString*)name;
- (void)removeNode:(BTNode*)node;

@property(nonatomic,readonly) RAFloatSignal *update;
@property(nonatomic,readonly) RAUnitSignal *entered;
@property(nonatomic,readonly) RAUnitSignal *exited;
@property(nonatomic,readonly) BTModeStack *stack;
@property(nonatomic,readonly) SPSprite *sprite;


@end
