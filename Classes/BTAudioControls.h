//
// Betwixt - Copyright 2012 Three Rings Design

@class BTAudioState;

@interface BTAudioControls : NSObject {
    BTAudioControls* _parent;
    NSMutableArray* _children;

    BTAudioState* _localState;
    BTAudioState* _globalState;

    float _initialVolume;
    float _targetVolumeDelta;
    float _targetVolumeElapsedTime;
    float _targetVolumeTotalTime;

    float _initialPan;
    float _targetPanDelta;
    float _targetPanElapsedTime;
    float _targetPanTotalTime;

    float _initialPitch;
    float _targetPitchDelta;
    float _targetPitchElapsedTime;
    float _targetPitchTotalTime;

    BOOL _targetPause;
    float _pauseCountdown;

    BOOL _targetMute;
    float _muteCountdown;

    BOOL _targetStop;
    float _stopCountdown;
}

@property (nonatomic,readonly) BTAudioState* state;

- (id)initWithParentControls:(BTAudioControls*)parentControls;
- (id)init;

- (BTAudioControls*)createChild;

- (BTAudioControls*)setVolume:(float)volume;
- (BTAudioControls*)setVolume:(float)volume overTime:(float)time;
- (BTAudioControls*)setPitch:(float)pitch;
- (BTAudioControls*)setPitch:(float)pitch overTime:(float)time;
- (BTAudioControls*)fadeOut:(float)time;
- (BTAudioControls*)fadeIn:(float)time;
- (BTAudioControls*)fadeOutAndStop:(float)time;
- (BTAudioControls*)setPan:(float)pan;
- (BTAudioControls*)setPan:(float)pan overTime:(float)time;
- (BTAudioControls*)setPaused:(BOOL)paused;
- (BTAudioControls*)setPaused:(BOOL)paused after:(float)time;
- (BTAudioControls*)setMuted:(BOOL)mute;
- (BTAudioControls*)setMuted:(BOOL)mute after:(float)time;
- (BTAudioControls*)setStopped:(BOOL)stop;
- (BTAudioControls*)setStopped:(BOOL)stop after:(float)time;

- (BTAudioControls*)pause;
- (BTAudioControls*)resume;
- (BTAudioControls*)mute;
- (BTAudioControls*)unmute;
- (BTAudioControls*)stop;
- (BTAudioControls*)play;

- (void)update:(float)dt parentState:(BTAudioState*)parentState;
- (BTAudioState*)updateStateNow;

@end
