#import "RepeatingMode.h"
#import "BTRepeatingTask.h"
#import "BTLocationTask.h"
#import "BTTaskSequence.h"

@implementation RepeatingMode

- (id)init {
    if (!(self = [super init])) return nil;
    SPQuad *directquad = [SPQuad quadWithWidth:100 height:100 color:0xff0000];
    [self.sprite addChild:directquad];
    __block int reps = 0;
    [self addNode:[BTRepeatingTask withTaskCreator:^BTNode* (BTRepeatingTask *owner){
        if (reps++ == 2) [self detach];
        return [BTTaskSequence seqWithNodes:
            [[BTLocationTask alloc] initWithTime:.25f toX:100 toY:100],
            [[BTLocationTask alloc] initWithTime:.25f toX:200 toY:200],
            nil];

    }]];
    return self;
}

@end
