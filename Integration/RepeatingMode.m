//
// Betwixt - Copyright 2012 Three Rings Design

#import "RepeatingMode.h"
#import "BTMode+Protected.h"
#import "BTRepeatingTask.h"
#import "BTRotationTask.h"
#import "BTParallelTask.h"
#import "BTLocationTask.h"
#import "BTSequenceTask.h"
#import "BTModeStack.h"

@implementation RepeatingMode

- (void)setup {
    [super setup];
    
    SPQuad *directquad = [SPQuad quadWithWidth:100 height:100 color:0xff0000];
    [self.sprite addChild:directquad];
    __block int reps = 0;
    [self addNode:[BTRepeatingTask withTaskCreator:^BTNode* {
        if (reps++ == 2) [self.modeStack popMode];
        return [BTSequenceTask withNodes:
                    [BTParallelTask withNodes:
                        [BTLocationTask withTime:.25f toX:100 toY:100],
                        [BTRotationTask withTime:.25f rotation:1.0f],
                        nil],
                    [BTParallelTask withNodes:
                        [BTLocationTask withTime:.25f toX:200 toY:200],
                        [BTRotationTask withTime:.25f rotation:0],
                        nil],
                nil];

    }]];
}

@end
