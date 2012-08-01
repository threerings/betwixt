//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTNodeContainer.h"

@class BTModeStack;
@class BTSpriteObject;
@class BTInput;
@class BTViewObject;

@interface BTMode : NSObject <BTNodeContainer> {
@package
    __weak BTModeStack* _modeStack;
    BOOL _isLive;
    BTInput* _input;
    RAFloatSignal* _update;
    RAUnitSignal* _entered;
    RAUnitSignal* _exited;
    RAConnectionGroup* _conns;
    BTSpriteObject* _rootNode;
    NSMutableDictionary* _keyedObjects;
    NSMutableDictionary* _groups;
    SPJuggler* _juggler;
    NSUInteger _nextNodeId;

    float _runningTime;
}

@property (nonatomic,readonly) RAFloatSignal* update;
@property (nonatomic,readonly) RAUnitSignal* entered;
@property (nonatomic,readonly) RAUnitSignal* exited;
@property (nonatomic,readonly) BTModeStack* modeStack;
@property (nonatomic,readonly) SPSprite* sprite;
@property (nonatomic,readonly) BTInput* input;
@property (nonatomic,readonly) float runningTime; // the number of seconds this mode has been active

- (BTNode*)nodeForKey:(NSString*)key;
/// Returns the nodes in the group or nil if there are no nodes in the group.
- (id<NSFastEnumeration>)nodesInGroup:(NSString*)group;
- (int)countNodesInGroup:(NSString*)group;


@end
