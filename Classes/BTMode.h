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
    BTModeStack *_stack;
}

- (BTNode*)nodeForKey:(NSString*)key;

@property(nonatomic,readonly) RADoubleSignal *update;
@property(nonatomic,readonly) SPSprite *sprite;

@end
