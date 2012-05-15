//
// Betwixt - Copyright 2012 Three Rings Design

@class BTAudioControls;
@class BTSoundResource;

@interface BTAudioChannel : NSObject {
@protected
    RAUnitSignal* _completed;
    BTSoundResource* _sound;
    SPSoundChannel* _spChannel;
    BTAudioControls* _controls;
    BOOL _loop;
    double _startTime;
}

/// Dispatched when the AudioChannel has completed playing. If the channel loops, the signal will
/// dispatch after it has completed looping.
/// The signal will not dispatch if the channel is manually stopped.
@property (nonatomic,readonly) RAReactor* completed;
@property (nonatomic,readonly) BTSoundResource* sound;
@property (nonatomic,readonly) double startTime;
@property (nonatomic,readonly) BOOL loop;
@property (nonatomic,readonly) BOOL isPlaying;
@property (nonatomic,readonly) BOOL isPaused;
@property (nonatomic,readonly) BTAudioControls* controls;

@end
