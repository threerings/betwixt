//
// Betwixt - Copyright 2012 Three Rings Design

#import "MoveMode.h"

#import "BTBlockTask.h"
#import "BTTaskSequence.h"
#import "BTAlphaTask.h"
#import "BTRotationTask.h"
#import "BTSprite.h"
#import "BTLocationTask.h"
#import "BTModeStack.h"

@implementation MoveMode
- (id)init {
    if (!(self = [super init])) return nil;
    SPQuad *directquad = [SPQuad quadWithWidth:100 height:100 color:0xff0000];
    [self.sprite addChild:directquad];
    [self addNode:[[BTLocationTask alloc] initWithTime:0.5 toX:100 toY:100 display:directquad]];
    [self addNode:[[BTAlphaTask alloc] initWithTime:0.5 alpha:0 display:directquad]];
    BTSprite *sprite = [[BTSprite alloc] init];
    [self addAndDisplayNode:sprite];
    [sprite.sprite addChild:[SPQuad quadWithWidth:100 height:100 color:0x00ff00]];
    [sprite addNode:[BTTaskSequence seqWithNodes:
        [[BTLocationTask alloc] initWithTime:0.5 toX:200 toY:200],
        [[BTRotationTask alloc] initWithTime:0.5 rotation:2],
        [BTBlockTask onAttach:^(BTBlockTask *task) {
            NSAssert(sprite.sprite.x == 200, nil);
            NSAssert(sprite.sprite.rotation == 2, nil);
        }],
        [BTBlockTask onAttach:^(BTBlockTask *task) { [_stack popMode]; }],
        nil]];
    return self;
}

@end
