//
// Betwixt - Copyright 2012 Three Rings Design

@class BTAudioControls;
@class BTAudioChannel;
@class BTSoundResource;
@class BTSoundType;
@class BTAudioState;
@class BTAudioSettings;

@interface BTAudioManager : NSObject {
@protected
    BTAudioControls* _masterControls;
    BTAudioControls* _sfxControls;
    BTAudioControls* _musicControls;
    BTAudioState* _defaultState;
    NSMutableArray* _activeChannels;
    BTAudioSettings* _settings;
}

@property (nonatomic,readonly) BTAudioControls* masterControls;
@property (nonatomic,readonly) BTAudioControls* sfxControls;
@property (nonatomic,readonly) BTAudioControls* musicControls;
@property (nonatomic,readonly) BTAudioSettings* settings;

- (BTAudioControls*)getControlsForSoundType:(BTSoundType*)type;

- (BTAudioChannel*)playSoundNamed:(NSString*)name;
- (BTAudioChannel*)playSoundNamed:(NSString*)name initialState:(BTAudioState*)initialState;
- (BTAudioChannel*)playSoundNamed:(NSString*)name loop:(BOOL)loop;
- (BTAudioChannel*)playSoundNamed:(NSString*)name 
                     initialState:(BTAudioState*)initialState
                   parentControls:(BTAudioControls*)parentControls 
                             loop:(BOOL)loop;
- (BTAudioChannel*)playSound:(BTSoundResource*)soundResource
                initialState:(BTAudioState*)initialState
              parentControls:(BTAudioControls*)parentControls 
                        loop:(BOOL)loop;

- (void)stopAllSounds;

@end
