//
// Betwixt - Copyright 2012 Three Rings Design

@class BTMovie;
@class BTMovieResourceLayer;

@interface BTMovieLayer : NSObject {
@public
    int keyframeIdx;// The index of the last keyframe drawn in drawFrame
    int layerIdx;// This layer's index in the movie
    NSMutableArray* keyframes;// <BTMovieResourceKeyframe*>
    // The DisplayObjects that are shown for each keyframe
    NSMutableArray* displays;// <SPDisplayObject*>
    // The movie this layer belongs to
    __weak BTMovie* movie;
    // If the keyframe has changed since the last drawFrame
    BOOL changedKeyframe;
}

- (id)initWithMovie:(BTMovie*)parent layer:(BTMovieResourceLayer*)layer;
- (void)drawFrame:(int)frame;

@end
