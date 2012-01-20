//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "SPSprite.h"
#import "BTMode.h"

@interface BTModeStack : NSObject {
@package
    NSMutableArray *_stack;
    NSMutableArray *_pendingModeTransitions;
    SPSprite *_sprite;
}

@property (nonatomic, readonly) BTMode *topMode;

- (void)pushMode:(BTMode *)mode;
- (void)popMode;
- (void)changeMode:(BTMode *)mode;
- (void)insertMode:(BTMode *)mode atIndex:(int)index;
- (void)removeModeAt:(int)index;
- (void)unwindToMode:(BTMode *)mode;
- (void)clear;

@end
