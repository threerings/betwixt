//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTAudioChannel.h"
#import "BTAudioChannel+Package.h"
#import "BTSoundResource.h"
#import "BTAudioControls.h"
#import "BTAudioState.h"

static BTAudioControls* GetDummyControls () {
    static BTAudioControls* gDummyControls = nil;
    if (gDummyControls == nil) {
        gDummyControls = [[BTAudioControls alloc] init];
    }
    return gDummyControls;
}

@implementation BTAudioChannel

@synthesize sound = _sound;
@synthesize loop = _loop;
@synthesize startTime = _startTime;

- (id)initWithControls:(BTAudioControls*)controls sound:(BTSoundResource*)sound 
             startTime:(double)startTime loop:(BOOL)loop {
    if ((self = [super init])) {
        _controls = controls;
        _sound = sound;
        _startTime = startTime;
        _loop = loop;
    }
    return self;
}

- (RAUnitSignal*)completed {
    // lazily created
    if (_completed == nil) {
        _completed = [[RAUnitSignal alloc] init];
    }
    return _completed;
}

- (void)update {
    if (self.isPlaying) {
        BTAudioState* state = _controls.state;
        if (state.stopped) {
            [self stop];
        } else if (state.paused && !self.isPaused) {
            [_spChannel pause];
        } else if (!state.paused && self.isPaused) {
            [_spChannel play];
        }
        
        if (self.isPlaying && !self.isPaused) {
            _spChannel.volume = state.actualVolume * _sound.volume;
        }
    }
}

- (void)setVolume:(float)volume {
    _spChannel.volume = volume;
}

- (BOOL)isPlaying {
    return (_sound != nil);
}

- (BOOL)isPaused {
    return (_sound != nil && _spChannel.isPaused);
}

- (BTAudioControls*)controls {
    return (_controls != nil ? _controls : GetDummyControls());
}

- (void)playWithState:(BTAudioState*)state {
    _spChannel = [_sound.sound createChannel];
    [_spChannel addEventListener:@selector(handleComplete:) 
                        atObject:self 
                         forType:SP_EVENT_TYPE_SOUND_COMPLETED];
    _spChannel.loop = _loop;
    _spChannel.volume = state.actualVolume * _sound.volume;
    //_spChannel.pan = state.pan * _sound.pan;
    if (state.paused) {
        [_spChannel pause];
    } else {
        [_spChannel play];
    }
}

- (void)stop {
    if (self.isPlaying) {
        if (_spChannel != nil) {
            [_spChannel removeEventListener:@selector(handleComplete:) 
                                   atObject:self 
                                    forType:SP_EVENT_TYPE_SOUND_COMPLETED];
            [_spChannel stop];
            _spChannel = nil;
        }
        _controls = nil;
        _sound = nil;
    }
}

- (void)handleComplete:(SPEvent*)event {
    [self stop];
    [_completed emit];
}

@end
