//
//  Betwixt - Copyright 2011 Three Rings Design

#import "NamedNodeMode.h"
#import "BTSprite.h"
#import "BTLocationTask.h"
#import "BTDestroyParentTask.h"
#import "BTBlockTask.h"
#import "BTDelayTask.h"
#import "BTTaskSequence.h"

@implementation NamedNodeMode
- (id)init {
    if (!(self = [super init])) return nil;
    BTSprite *sprite = [BTSprite new];
    [self displayNode:sprite];
    [sprite.sprite addChild:[SPQuad quadWithWidth:100 height:100 color:0x0000ff]];
    [sprite addNode:[[BTLocationTask alloc] initOverTime:1.0 toX:300 toY:200] withName:@"mover"];
    [sprite addNode:[BTTaskSequence seqWithNodes:
        [BTDelayTask delayFor:.25],
        [BTBlockTask onAttach:^(BTBlockTask *task) { [[sprite nodeForName:@"mover"] detach]; }],
        [BTDelayTask delayFor:.25],
        [BTBlockTask onAttach:^(BTBlockTask *task) {
            NSAssert(sprite.sprite.x > 0, nil);
            NSAssert(sprite.sprite.x < 100, nil);
        }],
        [[BTDestroyParentTask alloc] init],
        nil]];
    return self;
}

@end
