//
//  Betwixt - Copyright 2012 Three Rings Design

#import "FlipbookMode.h"

#import "BTDetachTask.h"
#import "BTMovieResource.h"
#import "BTMovie.h"
#import "BTModeStack.h"

@implementation FlipbookMode
- (id)init {
    if (!(self = [super init])) return nil;
    BTMovie *movie = [BTMovieResource newMovie:@"guybrush"];
    movie.x = movie.width;
    movie.y = movie.height;
    [self.sprite addChild:movie];
    [movie loopFromFrame:0];
    return self;
}
@end
