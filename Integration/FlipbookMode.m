//
//  Betwixt - Copyright 2012 Three Rings Design

#import "FlipbookMode.h"
#import "BTMode+Protected.h"

#import "BTMovieResource.h"
#import "BTMovie.h"
#import "BTModeStack.h"
#import "BTRotationTask.h"
#import "BTRepeatingTask.h"
#import "BTSequenceTask.h"

static SPQuad* FillRect (float width, float height, uint color) {
    SPQuad* quad = [[SPQuad alloc] initWithWidth:width height:height];
    quad.color = color;
    return quad;
}

@implementation FlipbookMode

- (void)setup {
    [self.sprite addChild:FillRect(320, 480, 0xffffffff)];
    
    for (int ii = 0; ii < 6; ii++) {
        BTMovie *movie = [BTMovieResource newMovie:@"guybrush/guybrush"];
        movie.x = movie.width + ii / 3 * movie.width;
        movie.y = movie.height + ii % 3 * movie.height - 50;
        [self.sprite addChild:movie];
        [movie playFromFrame:0];
        [self addNode:[BTRepeatingTask withTaskCreator:^BTNode*  {
            return [BTSequenceTask withNodes:
                     [BTRotationTask withTime:1.0 rotation:1 * ii target:movie],
                     [BTRotationTask withTime:1.0 rotation:-1 * ii target:movie], nil];
        }]];
    }
    
    BTSpriteObject* parent = [BTSpriteObject spriteObject];
    parent.sprite.x = 50;
    parent.sprite.y = 50;
    [self addNode:parent displayOn:self.sprite];
    [parent.sprite addChild:FillRect(100, 100, 0xff000000)];
    
    
    BTSpriteObject* clip1 = [BTSpriteObject spriteObject];
    clip1.sprite.clipRect = [SPRectangle rectangleWithX:10 y:0 width:90 height:200];
    [self addNode:clip1 displayOn:parent.sprite];
    
    clip1.display.scaleY = 0.6f;
    
    SPSprite* clip2 = [SPSprite sprite];
    clip2.clipRect = [SPRectangle rectangleWithX:0 y:0 width:90 height:200];
    [clip1.sprite addChild:clip2];
    
    SPQuad* quad = FillRect(100, 200, 0xff0000ff);
    [clip2 addChild:quad];
    
    [_conns onReactor:clip1.touchBegan connectUnit:^{
        NSLog(@"touched");
    }];
}

@end
