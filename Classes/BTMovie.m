//
// Betwixt - Copyright 2011 Three Rings Design

#import "BTMovie.h"
#import "BTMovie+Package.h"
#import "BTApp.h"
#import "BTMovieResourceKeyframe.h"
#import "BTResourceManager.h"
#import "BTTextureResource.h"
#import "BTMovieResourceLayer.h"

@interface BTMovieLayer : SPSprite {
@public
    int keyframeIdx;
    NSMutableArray *keyframes;
}
@end

@implementation BTMovieLayer
-(BTMovieResourceKeyframe*)kfAtIdx:(int)idx {
    return (BTMovieResourceKeyframe*)[keyframes objectAtIndex:0];
}

- (id)initWithLayer:(BTMovieResourceLayer*)layer {
    if (!(self = [super init])) return nil;
    self.name = layer->name;
    keyframes = layer->keyframes;
    BTTextureResource *tex = (BTTextureResource*)[[BTApp resourceManager] requireResource:[self kfAtIdx:0]->libraryItem];
    // TODO - texture offset
    [self addChild:[[SPImage alloc] initWithTexture:tex.texture]];
    return self;
}

- (void)drawFrame:(int)frame {
    while (keyframeIdx < [keyframes count] - 1 && [self kfAtIdx:keyframeIdx + 1]->index >= frame) {
        keyframeIdx++;
    }
    float x, y, scaleX, scaleY, rotation;
    BTMovieResourceKeyframe *kf = [keyframes objectAtIndex:keyframeIdx];
    if (keyframeIdx == [keyframes count] || kf->index == frame) {
        x = kf->x;
        y = kf->y;
        scaleX = kf->scaleX;
        scaleY = kf->scaleY;
        rotation = kf->rotation;
    } else {
        // TODO - interpolation types other than linear
        float interped = (frame - kf->index)/kf->duration;
        BTMovieResourceKeyframe *nextKf = [keyframes objectAtIndex:keyframeIdx + 1];
        x = kf->x + (nextKf->x - kf->x) * interped;
        y = kf->y + (nextKf->y - kf->y) * interped;
        scaleX = kf->scaleX + (nextKf->scaleX - kf->scaleX) * interped;
        scaleY = kf->scaleY + (nextKf->scaleY - kf->scaleY) * interped;
        rotation = kf->rotation + (nextKf->rotation - kf->rotation) * interped;
    }
}
@end


@implementation BTMovie {
    int _frame, _frames;
    BOOL _stopped;
    float _playTime;
}

- (void)drawFrame:(int)newFrame {
    if (newFrame < _frame) for (BTMovieLayer *layer in _sprite) layer->keyframeIdx = 0;
    for (BTMovieLayer *layer in _sprite) [layer drawFrame:newFrame];
}

- (int)frame { return _frame; }
- (void)setFrame:(int)newFrame {
    if (_frame == newFrame) return;
    [self drawFrame:newFrame];
    _frame = newFrame;

    _playTime = (float) _frame / 30; // reset playtime
}

- (void)update:(float) dt {
    if (_stopped) return;
    _playTime += dt;
    self.frame = (int)(_playTime * 30) % _frames;
}

- (id)initWithLayers:(NSMutableArray*)layers {
    if (!(self = [super init])) return nil;
    for (BTMovieResourceLayer *layer in layers) {
        [_sprite addChild:[[BTMovieLayer alloc] initWithLayer:layer]];
    }
    [self drawFrame:0];
    return self;
}
@end
