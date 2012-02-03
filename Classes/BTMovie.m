//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMovie.h"
#import "BTMovie+Package.h"
#import "BTApp.h"
#import "BTMovieResourceKeyframe.h"
#import "BTResourceManager.h"
#import "BTTextureResource.h"
#import "BTMovieResourceLayer.h"

NSString * const BTMovieFirstFrame = @"BTMovieFirstFrame";
NSString * const BTMovieLastFrame = @"BTMovieLastFrame";
@interface BTMovieLayer : SPSprite {
@public
    int keyframeIdx;
    NSMutableArray *keyframes;
}
@end

#define NO_FRAME -1
@implementation BTMovieLayer
-(BTMovieResourceKeyframe*)kfAtIdx:(int)idx {
    return (BTMovieResourceKeyframe*)[keyframes objectAtIndex:idx];
}

- (id)initWithLayer:(BTMovieResourceLayer*)layer {
    if (!(self = [super init])) return nil;
    self.name = layer->name;
    keyframes = layer->keyframes;
    BTTextureResource *tex = [BTApp.app.resourceManager requireResource:[self kfAtIdx:0]->libraryItem];
    // TODO - texture offset
    SPImage *img = [[SPImage alloc] initWithTexture:tex.texture];
    img.x = tex.offset.x;
    img.y = tex.offset.y;
    [self addChild:img];
    return self;
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
    BOOL _goingToFrame;
    int _pendingFrame;
    int _frame, _stopFrame;
    RABoolValue *_playing;
    float _playTime, _duration;
    RAObjectSignal *_labelPassed;
    NSArray *_labels;
}

- (int)frameForLabel:(NSString*)label {
    for (int ii = 0; ii < [_labels count]; ii++) {
        if ([[_labels objectAtIndex:ii] containsObject:label]) return ii;
    }
    @throw([NSException
        exceptionWithName:@"UnknownLabel"
        reason:[NSString stringWithFormat:@"Unknown label '%@'", label]
        userInfo:nil]);
}

- (RAConnection*)monitorLabel:(NSString *)label withUnit:(RAUnitBlock)slot {
    return [_labelPassed connectSlot:^(id labelFired) {
        if ([labelFired isEqual:label]) slot();
    }];
}

- (void)fireLabelsFrom:(int)startFrame to:(int)endFrame {
    for (int ii = startFrame; ii <= endFrame; ii++) {
        for (NSString *label in [_labels objectAtIndex:ii]) [_labelPassed emitEvent:label];
    }
}

- (void)gotoFrame:(int)newFrame fromSkip:(BOOL)fromSkip overDuration:(BOOL)overDuration {
    if (_goingToFrame) {
        _pendingFrame = newFrame;
        return;
    }
    _goingToFrame = YES;
    BOOL differentFrame = newFrame != _frame;
    BOOL wrapped = newFrame < _frame;
    if (differentFrame) {
        if (wrapped) for (BTMovieLayer *layer in _sprite) layer->keyframeIdx = 0;
        for (BTMovieLayer *layer in _sprite) [layer drawFrame:newFrame];
    }

    // Update the frame before firing, so if firing changes the frame, it should stick.
    int oldFrame = _frame;
    _frame = newFrame;
    if (fromSkip) {
        [self fireLabelsFrom:newFrame to:newFrame];
        _playTime = newFrame/30.0f;
    } else if (overDuration) {
        [self fireLabelsFrom:oldFrame + 1 to:[_labels count] - 1];
        [self fireLabelsFrom:0 to:_frame];
    } else if (differentFrame) {
        if (wrapped) {
            [self fireLabelsFrom:oldFrame + 1 to:[_labels count] - 1];
            [self fireLabelsFrom:0 to:_frame];
        } else [self fireLabelsFrom:oldFrame + 1 to:_frame];
    }
    _goingToFrame = NO;
    if (_pendingFrame != NO_FRAME) {
        newFrame = _pendingFrame;
        _pendingFrame = NO_FRAME;
        [self gotoFrame:newFrame fromSkip:YES overDuration:NO];
    }
}

- (void)playToLabel:(NSString*)label {
  [self playToFrame:[self frameForLabel:label]];
}

- (void)playToFrame:(int)frame {
    _stopFrame = frame;
    _playing.value = YES;
}

- (void)playFromLabel:(NSString*)startLabel toLabel:(NSString*)stopLabel {
    [self playFromFrame:[self frameForLabel:startLabel] toFrame:[self frameForLabel:stopLabel]];
}

- (void)playFromFrame:(int)startFrame toLabel:(NSString*)stopLabel {
    [self playFromFrame:startFrame toFrame:[self frameForLabel:stopLabel]];
}
- (void)playFromLabel:(NSString*)startLabel toFrame:(int)stopFrame {
    [self playFromFrame:[self frameForLabel:startLabel] toFrame:stopFrame];
}

- (void)playFromFrame:(int)startFrame toFrame:(int)stopFrame {
    [self playToFrame:stopFrame];
    [self gotoFrame:startFrame fromSkip:YES overDuration:NO];
}

- (void)loopFromLabel:(NSString*)label {
    [self loopFromFrame:[self frameForLabel:label]];
}

- (void)loopFromFrame:(int)frame {
    _playing.value = YES;
    _stopFrame = NO_FRAME;
    [self gotoFrame:frame fromSkip:YES overDuration:NO];
}

- (void)gotoLabel:(NSString*)label {
    [self gotoFrame:[self frameForLabel:label]];
}

- (void)gotoFrame:(int)frame {
    _playing.value = NO;
    [self gotoFrame:frame fromSkip:YES overDuration:NO];
}

- (int)frames { return [_labels count]; }

- (void)update:(float)dt {
    if (!_playing.value) return;
    _playTime += dt;
    if (_playTime > _duration) _playTime = fmodf(_playTime, _duration);
    int newFrame = (int)(_playTime * 30);
    BOOL overDuration = dt >= _duration;
    // If the update crosses or goes to the stopFrame, go to the stop frame, stop the movie and
    // clear it
    if (_stopFrame != NO_FRAME &&
        ((newFrame >= _stopFrame && (_frame < _stopFrame || newFrame < _frame)) || overDuration)) {
        _playing.value = NO;
        newFrame = _stopFrame;
        _stopFrame = NO_FRAME;
    }
    [self gotoFrame:newFrame fromSkip:NO overDuration:overDuration];
}

- (id)initWithLayers:(NSMutableArray*)layers andLabels:(NSArray*)labels {
    if (!(self = [super init])) return nil;
    for (BTMovieResourceLayer *layer in layers) {
        BTMovieLayer *mLayer = [[BTMovieLayer alloc] initWithLayer:layer];
        [_sprite addChild:mLayer];
    }
    _pendingFrame = NO_FRAME;
    _stopFrame = NO_FRAME;
    _frame = NO_FRAME;
    _labels = labels;
    _duration = [labels count] / 30.0;
    _playing = [[RABoolValue alloc] init];
    _playing.value = YES;
    _labelPassed = [[RAObjectSignal alloc] init];
    [self gotoFrame:0 fromSkip:YES overDuration:NO];
    return self;
}

@synthesize duration=_duration, playing=_playing, labelPassed=_labelPassed, frame=_frame;
@end
