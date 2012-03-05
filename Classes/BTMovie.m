//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMovie.h"
#import "BTMovie+Package.h"
#import "BTApp.h"
#import "BTDisplayObjectCreator.h"
#import "BTMovieResourceKeyframe.h"
#import "BTResourceManager.h"
#import "BTTextureResource.h"
#import "BTMovieResourceLayer.h"
#import "BTJugglerContainer.h"

NSString * const BTMovieFirstFrame = @"BTMovieFirstFrame";
NSString * const BTMovieLastFrame = @"BTMovieLastFrame";
@interface BTMovieLayer : NSObject {
@public
    int keyframeIdx;// The index of the last keyframe drawn in drawFrame
    int layerIdx;// This layer's index in the movie
    NSMutableArray* keyframes;// <BTMovieResourceKeyframe*>
    // Only created if there are multiple symbols on this layer. If it does exist, the appropriate display is swapped in at keyframe changes. If it doesn't, the display is only added to the parent on layer creation
    NSMutableArray* displays;// <SPDisplayObject*>
    // The movie this layer belongs to
    __weak BTMovie* movie;
    // If the keyframe has changed since the last drawFrame
    BOOL changedKeyframe;
}
@end
SPDisplayObject* createDisplayObject(NSString* symbol);
SPDisplayObject* createDisplayObject(NSString* symbol) {
    if (!symbol) return [[SPSprite alloc] init];
    id<BTDisplayObjectCreator> res = [BTApp.app.resourceManager requireResource:symbol conformingTo:@protocol(BTDisplayObjectCreator)];
    return [res createDisplayObject];
}

#define NO_FRAME -1
@implementation BTMovieLayer
-(BTMovieResourceKeyframe*)kfAtIdx:(int)idx {
    return (BTMovieResourceKeyframe*)[keyframes objectAtIndex:idx];
}

- (id)initForMovie:(BTMovie*)parent withLayer:(BTMovieResourceLayer*)layer {
    if (!(self = [super init])) return nil;
    keyframes = layer->keyframes;
    NSString *lastSymbol = nil;
    movie = parent;
    for (int ii = 0; ii < [keyframes count] && !lastSymbol; ii++) {
        lastSymbol = [self kfAtIdx:ii]->libraryItem;
    }
    if (!lastSymbol) [movie addChild:[[SPSprite alloc] init]];// Label only movie
    else {
        BOOL multipleSymbols = false;
        for (BTMovieResourceKeyframe* kf in keyframes) {
            if (kf->libraryItem != lastSymbol) {
                multipleSymbols = true;
                break;
            }
        }
        if (!multipleSymbols) [movie addChild:createDisplayObject(lastSymbol)];
        else {
            displays = [[NSMutableArray alloc] initWithCapacity:[keyframes count]];
            for (BTMovieResourceKeyframe* kf in keyframes) {
                SPDisplayObject* display = createDisplayObject(kf->libraryItem);
                [displays addObject:display];
                display.name = layer->name;
            }
            [movie addChild:[displays objectAtIndex:0]];
        }
    }
    layerIdx = movie.numChildren - 1;
    [movie childAtIndex:layerIdx].name = layer->name;
    return self;
}

- (void)drawFrame:(int)frame {
    while (keyframeIdx < [keyframes count] - 1 && [self kfAtIdx:keyframeIdx + 1]->index <= frame) {
        keyframeIdx++;
        changedKeyframe = true;
    }
    if (changedKeyframe && displays) {// We've got multiple symbols. Swap in the one for this kf
        [movie removeChildAtIndex:layerIdx];
        [movie addChild:[displays objectAtIndex:keyframeIdx] atIndex:layerIdx];
    }
    changedKeyframe = false;

    BTMovieResourceKeyframe* kf = [self kfAtIdx:keyframeIdx];
    SPDisplayObject* layer = [movie childAtIndex:layerIdx];
    if (keyframeIdx == [keyframes count] - 1|| kf->index == frame) {
        layer.x = kf->x;
        layer.y = kf->y;
        layer.scaleX = kf->scaleX;
        layer.scaleY = kf->scaleY;
        layer.rotation = kf->rotation;
    } else {
        // TODO - interpolation types other than linear
        float interped = (frame - kf->index)/(float)kf->duration;
        BTMovieResourceKeyframe* nextKf = [self kfAtIdx:keyframeIdx + 1];
        layer.x = kf->x + (nextKf->x - kf->x) * interped;
        layer.y = kf->y + (nextKf->y - kf->y) * interped;
        layer.scaleX = kf->scaleX + (nextKf->scaleX - kf->scaleX) * interped;
        layer.scaleY = kf->scaleY + (nextKf->scaleY - kf->scaleY) * interped;
        layer.rotation = kf->rotation + (nextKf->rotation - kf->rotation) * interped;
    }
    
    layer.pivotX = kf->pivotX;
    layer.pivotY = kf->pivotY;
}
@end

// Proxies connections to the label monitor connecitions so that once only applies when the desired
// label is fired.
@interface LabelMonitorConnProxy : RAConnection {
@public
    RAConnection* _proxied;
    BOOL _oneShot;
}
@end
@implementation LabelMonitorConnProxy
-(void) proxiedDispatched {
    if (_oneShot) [_proxied disconnect];
}

-(RAConnection*) once {
    _oneShot = YES;
    return self;
}

-(void) disconnect {
    [_proxied disconnect];
}
@end

@implementation BTMovie {
    BOOL _goingToFrame;// If a call to gotoFrame is active
    int _pendingFrame;// Latest frame given to gotoFrame while _goingToFrame, or NO_FRAME if there isn't a queued frame move
    int _frame;// Last drawn frame
    int _stopFrame;// Frame on which playing stops, or NO_FRAME if we're looping or already stopped
    RABoolValue* _playing;
    float _playTime;// Time position of the playhead. Does not snap to frame boundaries.
    float _duration;// Length of the movie in seconds
    RAObjectSignal* _labelPassed;
    NSArray* _labels;// <NSArray<NSString>> by frame idx
    NSMutableArray* _layers;// <BTMovieLayer>
    __weak SPJuggler* _juggler;// The juggler advancing us if we're on the stage, or nil if we're not on the display list
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

- (RAConnection*)monitorLabel:(NSString*)label withUnit:(RAUnitBlock)slot {
    LabelMonitorConnProxy* proxy = [[LabelMonitorConnProxy alloc] init];
    RAConnection* realConn = [_labelPassed connectSlot:^(id labelFired) {
        if ([labelFired isEqualToString:label]) {
            slot();
            [proxy proxiedDispatched];
        }
    }];
    proxy->_proxied = realConn;
    return proxy;
}

- (void)fireLabelsFrom:(int)startFrame to:(int)endFrame {
    for (int ii = startFrame; ii <= endFrame; ii++) {
        for (NSString* label in [_labels objectAtIndex:ii]) [_labelPassed emitEvent:label];
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
        if (wrapped) {
            for (BTMovieLayer* layer in _layers) {
                layer->changedKeyframe = true;
                layer->keyframeIdx = 0;
            }
        }
        for (BTMovieLayer* layer in _layers) [layer drawFrame:newFrame];
    }

    // Update the frame before firing, so if firing changes the frame, it sticks.
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

- (void)advanceTime:(double)dt {
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

- (BOOL) isComplete { return NO; }

- (void)addedToStage:(SPEvent*)event {
    SPDisplayObject* parent = self.parent;
    while (parent) {
        if ([parent conformsToProtocol:@protocol(BTJugglerContainer)]) {
            _juggler = ((id<BTJugglerContainer>)parent).juggler;
            break;
        }
        parent = parent.parent;
    }
    if (!_juggler) _juggler = [[SPStage mainStage] juggler];
    [_juggler addObject:self];
}

- (void)removedFromStage:(SPEvent*)event {
    [_juggler removeObject:self];
    _juggler = nil;
}

- (id)initWithLayers:(NSMutableArray*)layers andLabels:(NSArray*)labels {
    if (!(self = [super init])) return nil;
    _layers = [[NSMutableArray alloc] initWithCapacity:[layers count]];
    for (BTMovieResourceLayer* layer in layers) {
        [_layers addObject:[[BTMovieLayer alloc] initForMovie:self withLayer:layer]];
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
    [self addEventListener:@selector(addedToStage:) atObject:self forType:SP_EVENT_TYPE_ADDED_TO_STAGE];
    [self addEventListener:@selector(removedFromStage:) atObject:self forType:SP_EVENT_TYPE_REMOVED_FROM_STAGE];
    return self;
}

@synthesize duration=_duration, playing=_playing, labelPassed=_labelPassed, frame=_frame;
@end
