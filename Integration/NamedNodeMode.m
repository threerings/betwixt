//
// Betwixt - Copyright 2012 Three Rings Design

#import "NamedNodeMode.h"
#import "BTSprite.h"
#import "BTLocationTask.h"
#import "BTDetachTask.h"
#import "BTBlockTask.h"
#import "BTWaitTask.h"
#import "BTSequenceTask.h"

@implementation NamedNodeMode
- (id)init {
    if (!(self = [super init])) return nil;
    BTSprite *sprite = [BTSprite new];
    [self addNode:sprite displayOn:self.sprite];
    [sprite.sprite addChild:[SPQuad quadWithWidth:100 height:100 color:0x0000ff]];
    [sprite addNode:[[BTLocationTask alloc] initWithTime:1 toX:300 toY:200] withName:@"mover"];
    [sprite addNode:[BTSequenceTask withNodes:
        [BTWaitTask waitFor:.25f],
        [BTDetachTask detachNode:[sprite nodeForName:@"mover"]],
        [BTWaitTask waitFor:.25f],
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
