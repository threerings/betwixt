//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTUserSettings.h"

@class BTAudioManager;

@interface BTAudioSettings : BTUserSettings {
@protected
    RABoolValue* _musicEnabled;
    RAFloatValue* _musicVolume;
    RABoolValue* _sfxEnabled;
    RAFloatValue* _sfxVolume;
}

- (id)initWithAudio:(BTAudioManager*)audio;

@property (readonly) RABoolValue* musicEnabled;
@property (readonly) RAFloatValue* musicVolume;
@property (readonly) RABoolValue* sfxEnabled;
@property (readonly) RAFloatValue* sfxVolume;

@end
