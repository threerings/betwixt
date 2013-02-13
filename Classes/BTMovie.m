//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMovie.h"
#import "BTMovie+Package.h"
#import "BTMovieLayer.h"
#import "BTMovieResourceKeyframe.h"
#import "BTMovieResourceLayer.h"
#import "BTJugglerContainer.h"

static const int NO_FRAME = -1;

NSString* const BTMovieFirstFrame = @"BTMovieFirstFrame";
NSString* const BTMovieLastFrame = @"BTMovieLastFrame";

// Proxies connections to the label monitors so that 'once' only applies when the desired
// label is fired.
@interface LabelMonitorConnProxy : RAConnection {
@public
    RAConnection* _proxied;
    BOOL _oneShot;
}
@end
@implementation LabelMonitorConnProxy
- (void)proxiedDispatched {
    if (_oneShot) {
        [self disconnect];
    }
}

- (RAConnection*)once {
    _oneShot = YES;
    return self;
}

- (void)disconnect {
    [_proxied disconnect];
    _proxied = nil;
}
@end

@implementation BTMovie

@synthesize duration = _duration;
@synthesize playing = _playing;
@synthesize labelPassed = _labelPassed;
@synthesize frame = _frame;
@synthesize framerate = _framerate;

- (id)initWithFramerate:(float)framerate layers:(NSArray*)layers labels:(NSArray*)labels {
    if ((self = [super init])) {
        _framerate = framerate;
        _layers = [layers map:^BTMovieLayer* (BTMovieResourceLayer* layer) {
            return [[BTMovieLayer alloc] initWithMovie:self layer:layer];
        }];
        _pendingFrame = NO_FRAME;
        _stopFrame = NO_FRAME;
        _frame = NO_FRAME;
        _labels = labels;
        _duration = [labels count] / _framerate;
        _playing = [[RABoolValue alloc] init];
        _playing.value = YES;
        _labelPassed = [[RAObjectSignal alloc] init];
        [self updateFrame:0 dt:0];
        [self addEventListener:@selector(addedToStage:) atObject:self
                       forType:SP_EVENT_TYPE_ADDED_TO_STAGE];
        [self addEventListener:@selector(removedFromStage:) atObject:self
                       forType:SP_EVENT_TYPE_REMOVED_FROM_STAGE];
    }
    return self;
}

- (int)frameForLabel:(NSString*)label {
    for (int ii = 0; ii < [_labels count]; ii++) {
        if ([_labels[ii] containsObject:label]) {
            return ii;
        }
    }

    [NSException raise:@"UnknownLabel" format:@"Unknown label '%@'", label];
    return -1;
}

- (RAConnection*)monitorLabel:(NSString*)label withUnit:(RAUnitBlock)slot {
    LabelMonitorConnProxy* proxy = [[LabelMonitorConnProxy alloc] init];
    slot = [slot copy];
    RAConnection* realConn = [_labelPassed connectSlot:^(id labelFired) {
        if ([labelFired isEqualToString:label]) {
            slot();
            [proxy proxiedDispatched];
        }
    }];
    proxy->_proxied = realConn;
    return proxy;
}

- (void)updateFrame:(int)newFrame dt:(float)dt {
    NSAssert(newFrame >= 0 && newFrame < self.frames, @"bad frame: %d", newFrame);

    if (_isUpdatingFrame) {
        _pendingFrame = newFrame;
        return;
    } else {
        _pendingFrame = NO_FRAME;
        _isUpdatingFrame = YES;
    }
    
    BOOL isGoTo = (dt <= 0);
    BOOL wrapped = (dt >= _duration) || (newFrame < _frame);
    
    if (newFrame != _frame) {
        if (wrapped) {
            for (BTMovieLayer* layer in _layers) {
                layer->changedKeyframe = true;
                layer->keyframeIdx = 0;
            }
        }
        for (BTMovieLayer* layer in _layers) {
            [layer drawFrame:newFrame];
        }
    }

    if (isGoTo) {
        _playTime = newFrame / _framerate;
    }

    // Update the frame before firing frame label signals, so if firing changes the frame,
    // it sticks.
    int oldFrame = _frame;
    _frame = newFrame;

    // determine which labels to fire signals for
    int startFrame = 0;
    int frameCount = 0;
    if (isGoTo) {
        startFrame = newFrame;
        frameCount = 1;
    } else {
        startFrame = (oldFrame + 1 < self.frames ? oldFrame + 1 : 0);
        frameCount = (_frame - oldFrame);
        if (wrapped) {
            frameCount += self.frames;
        }
    }

    // Fire signals. Stop if pendingFrame is updated, which indicates that the client
    // has called goTo()
    for (int ii = 0; ii < frameCount; ++ii) {
        if (_pendingFrame != NO_FRAME) {
            break;
        }

        int frameIdx = (startFrame + ii) % self.frames;
        for (NSString* label in _labels[frameIdx]) {
            [_labelPassed emitEvent:label];
            if (_pendingFrame != NO_FRAME) {
                break;
            }
        }
    }

    _isUpdatingFrame = NO;
    // If we were interrupted by a goTo(), update to that frame now.
    if (_pendingFrame != NO_FRAME) {
        newFrame = _pendingFrame;
        [self updateFrame:newFrame dt:0];
    }
}

- (void)playOnce {
    [self playFromFrame:0 toFrame:self.frames - 1];
}

- (void)play {
    [self playFromFrame:self.frame];
}

- (void)stop {
    [self gotoFrame:self.frame];
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
    [self updateFrame:startFrame dt:0];
}

- (void)playFromLabel:(NSString*)label {
    [self playFromFrame:[self frameForLabel:label]];
}

- (void)playFromFrame:(int)frame {
    _playing.value = YES;
    _stopFrame = NO_FRAME;
    [self updateFrame:frame dt:0];
}

- (void)gotoLabel:(NSString*)label {
    [self gotoFrame:[self frameForLabel:label]];
}

- (void)gotoFrame:(int)frame {
    _playing.value = NO;
    [self updateFrame:frame dt:0];
}

- (int)frames {
    return [_labels count];
}

- (RAConnection*)addLoopWithStart:(NSString*)startLabel end:(NSString*)endLabel {
    __weak BTMovie* this = self;
    return [self monitorLabel:endLabel withUnit:^{
        [this playFromLabel:startLabel];
    }];
}

- (void)advanceTime:(double)dt {
    if (!_playing.value) {
        return;
    }

    _playTime += dt;
    float actualPlaytime = _playTime;
    if (_playTime >= _duration) _playTime = fmodf(_playTime, _duration);

    // If _playTime is very close to _duration, rounding error can cause us to
    // land on lastFrame + 1. Protect against that.
    int newFrame = MIN((int)(_playTime * _framerate), self.frames - 1);

    // If the update crosses or goes to the stopFrame:
    // go to the stopFrame, stop the movie, clear the stopFrame
    if (_stopFrame != NO_FRAME) {
        // how many frames remain to the stopframe?
        int framesRemaining =
            (_frame <= _stopFrame ? _stopFrame - _frame : self.frames - _frame + _stopFrame);
        int framesElapsed = (int)(actualPlaytime * _framerate) - _frame;
        if (framesElapsed >= framesRemaining) {
            _playing.value = NO;
            newFrame = _stopFrame;
            _stopFrame = NO_FRAME;
        }
    }

    [self updateFrame:newFrame dt:dt];
}

- (BOOL)isComplete {
    return NO;
}

- (void)addedToStage:(SPEvent*)event {
    SPDisplayObject* parent = self.parent;
    while (parent) {
        if ([parent conformsToProtocol:@protocol(BTJugglerContainer)]) {
            _juggler = ((id<BTJugglerContainer>)parent).juggler;
            break;
        }
        parent = parent.parent;
    }
    if (!_juggler) {
        _juggler = [[SPStage mainStage] juggler];
    }
    [_juggler addObject:self];
}

- (void)removedFromStage:(SPEvent*)event {
    [_juggler removeObject:self];
    _juggler = nil;
}

@end
