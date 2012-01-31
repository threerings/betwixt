//
// Betwixt - Copyright 2012 Three Rings Design

#import "NamedNodeMode.h"
#import "BTSprite.h"
#import "BTLocationTask.h"
#import "BTDetachTask.h"
#import "BTBlockTask.h"
#import "BTDelayTask.h"
#import "BTTaskSequence.h"

@implementation NamedNodeMode
- (id)init {
    if (!(self = [super init])) return nil;
    BTSprite *sprite = [BTSprite new];
    [self addAndDisplayNode:sprite];
    [sprite.sprite addChild:[SPQuad quadWithWidth:100 height:100 color:0x0000ff]];
    [sprite addNode:[[BTLocationTask alloc] initOverTime:1 toX:300 toY:200] withName:@"mover"];
    [sprite addNode:[BTTaskSequence seqWithNodes:
        [BTDelayTask delayFor:.25],
        [BTDetachTask detachNode:[sprite nodeForName:@"mover"]],
        [BTDelayTask delayFor:.25],
        [BTBlockTask onAttach:^(BTBlockTask *task) {
            NSAssert([sprite nodeForName:@"mover"] == nil, nil);
            NSAssert(sprite.sprite.x > 0, nil);
            NSAssert(sprite.sprite.x < 100, nil);
        }],
        [BTDetachTask detachParent],
        nil]];
    return self;
}

@end
