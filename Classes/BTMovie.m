//
// Betwixt - Copyright 2012 Three Rings Design

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
    return (BTMovieResourceKeyframe*)[keyframes objectAtIndex:idx];
}

- (id)initWithLayer:(BTMovieResourceLayer*)layer {
    if (!(self = [super init])) return nil;
    self.name = layer->name;
    keyframes = layer->keyframes;
    BTTextureResource *tex = [[BTApp resourceManager] requireResource:[self kfAtIdx:0]->libraryItem];
    // TODO - texture offset
    SPImage *img = [[SPImage alloc] initWithTexture:tex.texture];
    img.x = tex.offset.x;
    img.y = tex.offset.y;
    [self addChild:img];
    return self;
}

- (int) frames {
    BTMovieResourceKeyframe *last = [self kfAtIdx:[self->keyframes count] - 1];
    return last->index + last->duration;
}

- (void)drawFrame:(int)frame {
    while (keyframeIdx < [keyframes count] - 1 && [self kfAtIdx:keyframeIdx + 1]->index <= frame) {
        keyframeIdx++;
    }
    BTMovieResourceKeyframe *kf = [self kfAtIdx:keyframeIdx];
    if (keyframeIdx == [keyframes count] - 1|| kf->index == frame) {
        self.x = kf->x;
        self.y = kf->y;
        self.scaleX = kf->scaleX;
        self.scaleY = kf->scaleY;
        self.rotation = kf->rotation;
    } else {
        // TODO - interpolation types other than linear
        float interped = (frame - kf->index)/(float)kf->duration;
        BTMovieResourceKeyframe *nextKf = [self kfAtIdx:keyframeIdx + 1];
        self.x = kf->x + (nextKf->x - kf->x) * interped;
        self.y = kf->y + (nextKf->y - kf->y) * interped;
        self.scaleX = kf->scaleX + (nextKf->scaleX - kf->scaleX) * interped;
        self.scaleY = kf->scaleY + (nextKf->scaleY - kf->scaleY) * interped;
        self.rotation = kf->rotation + (nextKf->rotation - kf->rotation) * interped;
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
        BTMovieLayer *mLayer = [[BTMovieLayer alloc] initWithLayer:layer];
        [_sprite addChild:mLayer];
        if ([mLayer frames] > _frames) _frames = [mLayer frames];
    }
    [self drawFrame:0];
    return self;
}
@end
