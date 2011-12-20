//
//  Betwixt - Copyright 2011 Three Rings Design

#import "MoveMode.h"

#import "BTSprite.h"
#import "BTLocationTask.h"

@implementation MoveMode
- (id)init {
    if (!(self = [super init])) return nil;
    SPQuad *directquad = [SPQuad quadWithWidth:100 height:100 color:0xff0000];
    [self.sprite addChild:directquad];
    [self addObject:[[BTLocationTask alloc] initOverTime:5.0 toX:100 toY:100 onDisplay:directquad]];
    BTSprite *sprite = [[BTSprite alloc] init];
    [self addObject:sprite];
    [sprite.sprite addChild:[SPQuad quadWithWidth:100 height:100 color:0x00ff00]];
    [sprite addObject:[[BTLocationTask alloc] initOverTime:5.0 toX:200 toY:200 withInterpolator:BTEaseInOutInterpolator]];
    [self.sprite addChild:sprite.sprite];
    return self;
}

@end
