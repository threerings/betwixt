//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayNodeContainer.h"

@class BTModeStack;
@class BTSprite;

@interface BTMode : NSObject<BTDisplayNodeContainer> {
@package
    __weak BTModeStack *_stack;
    SPTouchProcessor *_touchProcessor;
    RAFloatSignal *_update;
    RAUnitSignal *_entered;
    RAUnitSignal *_exited;
    BTSprite *_rootNode;
    NSMutableDictionary *_keyedObjects;
    NSMutableDictionary *_groups;
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
