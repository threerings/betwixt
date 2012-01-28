//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "SPSprite.h"
#import "BTDisplayable.h"
#import "BTDisplayContext.h"
#import "BTNodeContainer.h"

@class BTModeStack;

@interface BTMode : BTNodeContainer<BTDisplayable,BTDisplayContext> {
@package
    __weak BTModeStack *_stack;
}

- (BTNode*)nodeForKey:(NSString*)key;
/// Returns the nodes in the group or nil if there are no nodes in the group.
- (NSArray*)nodesForGroup:(NSString*)group;

@property(nonatomic,readonly) RAFloatSignal *update;
@property(nonatomic,readonly) BTModeStack *stack;
@property(nonatomic,readonly) SPSprite *sprite;

@end
