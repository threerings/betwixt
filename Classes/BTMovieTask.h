//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTNode.h"

@class BTMovie;

@interface BTMovieTask : BTNode

/// Completes when the movie passes the given label
+ (BTMovieTask*)waitForLabel:(NSString*)label withMovie:(BTMovie*)movie;

/// Completes when the movie reaches its last frame
+ (BTMovieTask*)waitForComplete:(BTMovie*)movie;

@end
