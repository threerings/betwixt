//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "SPSprite.h"
#import "BTDisplayable.h"
#import "BTDisplayContext.h"
#import "BTContext.h"

@class BTModeStack;

@interface BTMode : BTContext<BTDisplayable,BTDisplayContext> {
@package
    BTModeStack *_stack;
@private
    SPSprite *_sprite;
    NSMutableDictionary *_namedObjects;
}

@property(nonatomic,readonly) RADoubleSignal *enterFrame;
@property(nonatomic,readonly) SPSprite *sprite;

@end
