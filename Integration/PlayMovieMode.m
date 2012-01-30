#import "PlayMovieMode.h"

#import "BTDetachTask.h"
#import "BTDelayTask.h"
#import "BTApp.h"
#import "BTTaskSequence.h"
#import "BTResourceManager.h"
#import "BTMovieResource.h"
#import "BTMovie.h"

@implementation PlayMovieMode
- (id)init {
    if (!(self = [super init])) return nil;
    BTMovieResource *res = [[BTApp resourceManager] requireResource:@"Animations/squaredance"];
    BTMovie *movie = [res newMovie];
    [self addAndDisplayNode:movie];
    [self addNode:[BTTaskSequence seqWithNodes:
        [BTDelayTask delayFor:movie.duration * 2],
        [BTDetachTask detachParent],
        nil]];
    return self;
}

@end
