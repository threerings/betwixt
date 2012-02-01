#import "PlayMovieMode.h"

#import "BTDetachTask.h"
#import "BTApp.h"
#import "BTResourceManager.h"
#import "BTMovieResource.h"
#import "BTMovie.h"

@implementation PlayMovieMode
- (id)init {
    if (!(self = [super init])) return nil;
    BTMovieResource *res = [[BTApp resourceManager] requireResource:@"Animations/squaredance"];
    BTMovie *movie = [res newMovie];
    [self addAndDisplayNode:movie];
    // Play the movie once and pop the mode
    [[movie monitorLabel:BTMovieLastFrame withUnit:^{
        [movie playFromFrame:0 toLabel:BTMovieLastFrame];
    }] once];
    [movie.playing connectUnit:^{ [self detach]; }];
    return self;
}

@end
