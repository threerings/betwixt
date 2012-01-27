#import "PlayMovieMode.h"

#import "BTApp.h"
#import "BTResourceManager.h"
#import "BTMovieResource.h"
#import "BTMovie.h"

@implementation PlayMovieMode
- (id)init {
    if (!(self = [super init])) return nil;
    BTMovieResource *res = (BTMovieResource*)[[BTApp resourceManager] requireResource:@"Animations/squaredance"];
    [self displayNode:[res newMovie]];
    return self;
}

@end
