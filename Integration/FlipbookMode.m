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

@implementation FlipbookMode

- (void)setup {
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
}

@end
