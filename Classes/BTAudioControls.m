//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTAudioControls.h"
#import "BTAudioState.h"

@interface BTAudioControls ()
- (void)attachChild:(BTAudioControls*)child;
- (NSMutableArray*)children;
@end

@implementation BTAudioControls

- (id)initWithParentControls:(BTAudioControls*)parentControls {
    if ((self = [super init])) {
        if (parentControls != nil) {
            _parent = parentControls;
            [_parent attachChild:self];
        }
        _localState = [BTAudioState defaultState];
        _globalState = [BTAudioState defaultState];
    }
    return self;
}

- (id)init {
    return [self initWithParentControls:nil];
}

- (NSMutableArray*)children {
    // lazily-initialized
    if (_children == nil) {
        _children = [[NSMutableArray alloc] init];
    }
    return _children;
}

- (BTAudioControls*)createChild {
    return [[BTAudioControls alloc] initWithParentControls:self];
}

- (void)attachChild:(BTAudioControls*)child {
    [self.children addObject:[OOOBoxedWeakRef createWith:child]];
}

- (BTAudioState*)state {
    return (_parent != nil ? _globalState : _localState);
}

- (BTAudioControls*)setVolume:(float)volume {
    return [self setVolume:volume overTime:0];
}

- (BTAudioControls*)setVolume:(float)volume overTime:(float)time {
    volume = SP_CLAMP(volume, 0, 1);
    _targetVolumeTotalTime = time;
    if (time <= 0) {
        _localState.volume = volume;
    } else {
        _initialVolume = _localState.volume;
        _targetVolumeDelta = volume - _initialVolume;
        _targetVolumeElapsedTime = 0;
    }
    return self;
}

- (BTAudioControls*)setPitch:(float)pitch {
    return [self setPitch:pitch overTime:0];
}

- (BTAudioControls*)setPitch:(float)pitch overTime:(float)time {
    _targetPitchTotalTime = time;
    if (time <= 0) {
        _localState.pitch = pitch;
    } else {
        _initialPitch = _localState.pitch;
        _targetPitchDelta = pitch - _initialPitch;
        _targetPitchElapsedTime = 0;
    }
    return self;
}

- (BTAudioControls*)fadeOut:(float)time {
    return [self setVolume:0 overTime:time];
}

- (BTAudioControls*)fadeIn:(float)time {
    return [self setVolume:1 overTime:time];
}

- (BTAudioControls*)fadeOutAndStop:(float)time {
    return [[self fadeOut:time] setStopped:YES after:time];
}

- (BTAudioControls*)setPan:(float)pan {
    return [self setPan:pan overTime:0];
}

- (BTAudioControls*)setPan:(float)pan overTime:(float)time {
    pan = SP_CLAMP(pan, -1, 1);
    _targetPanTotalTime = time;
    if (time <= 0) {
        _localState.pan = pan;
    } else {
        _initialPan = _localState.pan;
        _targetPanDelta = pan - _initialPan;
        _targetPanElapsedTime = 0;
    }
    return self;
}

- (BTAudioControls*)pause {
    return [self setPaused:YES after:0];
}

- (BTAudioControls*)resume {
    return [self setPaused:NO after:0];
}

- (BTAudioControls*)setPaused:(BOOL)paused {
    return [self setPaused:paused after:0];
}

- (BTAudioControls*)setPaused:(BOOL)paused after:(float)time {
    _pauseCountdown = time;
    if (time <= 0) {
        _localState.paused = paused;
    }
    return self;
}

- (BTAudioControls*)mute {
    return [self setMuted:YES after:0];
}

- (BTAudioControls*)unmute {
    return [self setMuted:NO after:0];
}

- (BTAudioControls*)setMuted:(BOOL)mute {
    return [self setMuted:mute after:0];
}

- (BTAudioControls*)setMuted:(BOOL)mute after:(float)time {
    _muteCountdown = time;
    if (time <= 0) {
        _localState.muted = mute;
    }
    return self;
}

- (BTAudioControls*)stop {
    return [self setStopped:YES after:0];
}

- (BTAudioControls*)play {
    return [self setStopped:NO after:0];
}

- (BTAudioControls*)setStopped:(BOOL)stop {
    return [self setStopped:stop after:0];
}

- (BTAudioControls*)setStopped:(BOOL)stop after:(float)time {
    _stopCountdown = time;
    if (time <= 0) {
        _localState.stopped = stop;
    }
    return self;
}

- (void)update:(float)dt parentState:(BTAudioState*)parentState {
    // update local state
    if (_targetVolumeTotalTime > 0) {
        _targetVolumeElapsedTime = MIN(_targetVolumeElapsedTime + dt, _targetVolumeTotalTime);
        _localState.volume = _initialVolume + 
            (_targetVolumeDelta * (_targetVolumeElapsedTime / _targetVolumeTotalTime));
        if (_targetVolumeElapsedTime >= _targetVolumeTotalTime) {
            _targetVolumeTotalTime = 0;
        }
    }
    
    if (_targetPanTotalTime > 0) {
        _targetPanElapsedTime = MIN(_targetPanElapsedTime + dt, _targetPanTotalTime);
        _localState.pan = _initialPan + 
            (_targetPanDelta * (_targetPanElapsedTime / _targetPanTotalTime));
        if (_targetPanElapsedTime >= _targetPanTotalTime) {
            _targetPanTotalTime = 0;
        }
    }
    
    if (_targetPitchTotalTime > 0) {
        _targetPitchElapsedTime = MIN(_targetPitchElapsedTime + dt, _targetPitchTotalTime);
        _localState.pitch = _initialPitch + 
            (_targetPitchDelta * (_targetPitchElapsedTime / _targetPitchTotalTime));
        if (_targetPitchElapsedTime >= _targetPitchTotalTime) {
            _targetPitchTotalTime = 0;
        }
    }
    
    if (_pauseCountdown > 0) {
        _pauseCountdown -= dt;
        if (_pauseCountdown <= 0) {
            _localState.paused = _targetPause;
        }
    }
    
    if (_muteCountdown > 0) {
        _muteCountdown -= dt;
        if (_muteCountdown <= 0) {
            _localState.muted = _targetMute;
        }
    }
    
    if (_stopCountdown > 0) {
        _stopCountdown -= dt;
        if (_stopCountdown <= 0) {
            _localState.stopped = _targetStop;
        }
    }
    
    // update global state
    [BTAudioState combine:_localState with:parentState into:_globalState];
    
    // update children
    if (_children != nil) {
        for (int ii = 0; ii < _children.count; ++ii) {
            __weak BTAudioControls* child = ((OOOBoxedWeakRef*) [_children objectAtIndex:ii]).value;
            if (child == nil) {
                // Nobody's holding a reference to the child
                [_children removeObjectAtIndex:ii--];
            } else {
                [child update:dt parentState:_globalState];
            }
        }
    }
}

- (BTAudioState*)updateStateNow {
    if (_parent != nil) {
        return [BTAudioState combine:_localState with:[_parent updateStateNow] into:_globalState];
    } else {
        return _localState;
    }
}

@end
