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

@synthesize completed = _completed;
@synthesize sound = _sound;
@synthesize loop = _loop;

- (id)init {
    if ((self = [super init])) {
        _completed = [[RAUnitSignal alloc] init];
    }
    return self;
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
    [_spChannel addEventListener:@selector(handleComplete) 
                        atObject:self 
                         forType:SP_EVENT_TYPE_SOUND_COMPLETED];
    _spChannel.loop = _loop;
    _spChannel.volume = state.actualVolume * _sound.volume;
    //_spChannel.pan = state.pan * _sound.pan;
    [_spChannel play];
}

- (void)stop {
    if (self.isPlaying) {
        if (_spChannel != nil) {
            [_spChannel removeEventListener:@selector(handleComplete) 
                                   atObject:self 
                                    forType:SP_EVENT_TYPE_SOUND_COMPLETED];
            [_spChannel stop];
            _spChannel = nil;
        }
        _controls = nil;
        _sound = nil;
    }
}

- (void)handleComplete {
    [self stop];
    [_completed emit];
}

@end
