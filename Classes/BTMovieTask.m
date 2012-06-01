//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMovieTask.h"
#import "BTNode+Protected.h"
#import "BTMovie.h"

@implementation BTMovieTask {
    BTMovie* _movie;
    NSString* _label;
}

+ (BTMovieTask*)waitForLabel:(NSString*)label withMovie:(BTMovie*)movie {
    return [[BTMovieTask alloc] initWithMovie:movie label:label];
}

+ (BTMovieTask*)waitForComplete:(BTMovie*)movie {
    return [[BTMovieTask alloc] initWithMovie:movie label:BTMovieLastFrame];
}

- (id)initWithMovie:(BTMovie*)movie label:(NSString*)label {
    if ((self = [super init])) {
        _movie = movie;
        _label = label;
    }
    return self;
}

- (void)added {
    [super added];
    [self.conns addConnection:[_movie monitorLabel:_label withUnit:^{
        [self removeSelf];
    }]];
}

@end
