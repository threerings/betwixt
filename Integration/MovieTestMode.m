//
// Betwixt - Copyright 2012 Three Rings Design

#import "MovieTestMode.h"
#import "BTMode+Protected.h"
#import "BTApp.h"
#import "BTResourceManager.h"
#import "BTMovie.h"
#import "BTMovieResource.h"

@implementation MovieTestMode

- (id)initWithResourceName:(NSString *)resourceName movieName:(NSString *)movieName {
    if ((self = [super init])) {
        _resourceName = resourceName;
        _movieName = movieName;
    }
    return self;
}

- (void)setup {
    [super setup];
    [BTApp.resourceManager loadResourceFiles:@[_resourceName]];
    
    // draw a background
    SPQuad* quad = [[SPQuad alloc] initWithWidth:BTApp.viewSize.x height:BTApp.viewSize.y];
    quad.color = 0xFF00FF;
    [self.sprite addChild:quad];
    
    BTMovie* movie = [BTMovieResource newMovie:_movieName];
    SPRectangle* bounds = [movie bounds];
    movie.x = ((BTApp.viewSize.x - bounds.width) * 0.5f) - bounds.x;
    movie.y = ((BTApp.viewSize.y - bounds.height) * 0.5f) - bounds.y;
    
    [self.sprite addChild:movie];
}

- (void)destroy {
    [BTApp.resourceManager unloadResourceFile:_resourceName];
    [super destroy];
}

@end
