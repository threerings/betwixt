//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTNodeContainer.h"

@class BTModeStack;
@class BTSprite;
@class BTInput;
@class BTDisplayObject;

@interface BTMode : NSObject <BTNodeContainer> {
@package
    __weak BTModeStack* _stack;
    BTInput* _input;
    RAFloatSignal* _update;
    RAUnitSignal* _entered;
    RAUnitSignal* _exited;
    BTSprite* _rootNode;
    NSMutableDictionary* _keyedObjects;
    NSMutableDictionary* _groups;
}

- (BTNode*)nodeForKey:(NSString*)key;
/// Returns the nodes in the group or nil if there are no nodes in the group.
- (NSArray*)nodesForGroup:(NSString*)group;

@property(nonatomic,readonly) RAFloatSignal* update;
@property(nonatomic,readonly) RAUnitSignal* entered;
@property(nonatomic,readonly) RAUnitSignal* exited;
@property(nonatomic,readonly) BTModeStack* stack;
@property(nonatomic,readonly) SPSprite* sprite;
@property(nonatomic,readonly) BTInput* input;


@end
