//
// Betwixt - Copyright 2012 Three Rings Design

#import "MoveMode.h"

#import "BTBlockTask.h"
#import "BTSequenceTask.h"
#import "BTAlphaTask.h"
#import "BTRotationTask.h"
#import "BTSpriteObject.h"
#import "BTLocationTask.h"
#import "BTModeStack.h"

@implementation MoveMode
- (id)init {
    if (!(self = [super init])) return nil;
    SPQuad *directquad = [SPQuad quadWithWidth:100 height:100 color:0xff0000];
    [self.sprite addChild:directquad];
    [self addNode:[BTLocationTask withTime:0.5 toX:100 toY:100 target:directquad]];
    [self addNode:[BTAlphaTask withTime:0.5 alpha:0 target:directquad]];
    BTSpriteObject *sprite = [[BTSpriteObject alloc] init];
    [self addNode:sprite displayOn:self.sprite];
    [sprite.sprite addChild:[SPQuad quadWithWidth:100 height:100 color:0x00ff00]];
    [sprite addNode:[BTSequenceTask withNodes:
        [[BTLocationTask alloc] initWithTime:0.5 toX:200 toY:200],
        [[BTRotationTask alloc] initWithTime:0.5 rotation:2],
        [BTBlockTask once:^(BTBlockTask *task) {
            NSAssert(sprite.sprite.x == 200, nil);
            NSAssert(sprite.sprite.rotation == 2, nil);
        }],
        [BTBlockTask once:^(BTBlockTask *task) { [_modeStack popMode]; }],
        nil]];
    return self;
}

@end
