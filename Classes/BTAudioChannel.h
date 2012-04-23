//
// Betwixt - Copyright 2012 Three Rings Design

@class BTAudioControls;
@class BTSoundResource;

@interface BTAudioChannel : NSObject {
@package
    RAUnitSignal* _completed;
    BTSoundResource* _sound;
    SPSoundChannel* _spChannel;
    BTAudioControls* _controls;
}


/// Dispatched when the AudioChannel has completed playing. If the channel loops, the signal will
/// dispatch after it has completed looping.
/// The signal will not dispatch if the channel is manually stopped.
@property (nonatomic,readonly) RAReactor* completed;
@property (nonatomic,readonly) BOOL isPlaying;
@property (nonatomic,readonly) BOOL isPaused;
@property (nonatomic,readonly) BTAudioControls* controls;

@end
