//
//  Betwixt - Copyright 2011 Three Rings Design

#import "MoveMode.h"

#import "BTTaskSequence.h"
#import "BTAlphaTask.h"
#import "BTRotationTask.h"
#import "BTSprite.h"
#import "BTLocationTask.h"

@implementation MoveMode
- (id)init {
    if (!(self = [super init])) return nil;
    SPQuad *directquad = [SPQuad quadWithWidth:100 height:100 color:0xff0000];
    [self.sprite addChild:directquad];
    [self addNode:[[BTLocationTask alloc] initOverTime:5.0 toX:100 toY:100 onDisplay:directquad]];
    [self addNode:[[BTAlphaTask alloc] initOverTime:5.0 toAlpha:0 onDisplay:directquad]];
    BTSprite *sprite = [[BTSprite alloc] init];
    [self addNode:sprite];
    [sprite.sprite addChild:[SPQuad quadWithWidth:100 height:100 color:0x00ff00]];
    [sprite addNode:[BTTaskSequence seqWithNodes:
        [[BTLocationTask alloc] initOverTime:5.0 toX:200 toY:200],
        [[BTRotationTask alloc] initOverTime:5.0 toRotation:2], nil]];
    [self.sprite addChild:sprite.sprite];
    return self;
}

@end
