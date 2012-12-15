//
// Betwixt - Copyright 2012 Three Rings Design

#import "NamedNodeMode.h"
#import "BTMode+Protected.h"
#import "BTSpriteObject.h"
#import "BTLocationTask.h"
#import "BTBlockTask.h"
#import "BTWaitTask.h"
#import "BTSequenceTask.h"
#import "BTModeStack.h"

@implementation NamedNodeMode
- (void)setup {
    [super setup];
    
    BTSpriteObject *sprite = [BTSpriteObject new];
    [self addNode:sprite displayOn:self.sprite];
    [sprite.sprite addChild:[SPQuad quadWithWidth:100 height:100 color:0x0000ff]];
    [sprite addNode:[BTLocationTask withTime:1 toX:300 toY:200] withName:@"mover"];
    [sprite addNode:[BTSequenceTask withNodes:@[
        [BTWaitTask withTime:.25f],
        [BTBlockTask once:^{
            [[sprite nodeForName:@"mover"] removeSelf];
        
        }],
        [BTWaitTask withTime:.25f],
        [BTBlockTask once:^{
            NSAssert([sprite nodeForName:@"mover"] == nil, nil);
            NSAssert(sprite.sprite.x > 0, nil);
            NSAssert(sprite.sprite.x < 100, nil);
            [self.modeStack popMode];
        }]
    ]]];
}

@end
