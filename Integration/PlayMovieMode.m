#import "PlayMovieMode.h"

#import "BTApp.h"
#import "BTResourceManager.h"
#import "BTMovieResource.h"
#import "BTMovie.h"

@implementation PlayMovieMode
- (id)init {
    if (!(self = [super init])) return nil;
    BTMovieResource *res = [[BTApp resourceManager] requireResource:@"Animations/squaredance"];
    BTMovie *movie = [res newMovie];
    __block int passes = 0;
    [movie.conns addConnection:[movie.frame connectSlot:^(int frame) {
        if (frame == (movie.frames - 1)) passes++;
        if (passes == 2) [movie.mode detach];
    }]];
    [self displayNode:movie];
    return self;
}

@end
