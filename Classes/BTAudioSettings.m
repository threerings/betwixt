//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTAudioSettings.h"
#import "BTAudioManager.h"
#import "BTAudioControls.h"

static NSString* const MUSIC_ENABLED = @"bt_music_enabled";
static NSString* const MUSIC_VOLUME = @"bt_music_volume";
static NSString* const SFX_ENABLED = @"bt_sfx_enabled";
static NSString* const SFX_VOLUME = @"bt_sfx_volume";

@implementation BTAudioSettings

@synthesize musicEnabled = _musicEnabled;
@synthesize musicVolume = _musicVolume;
@synthesize sfxEnabled = _sfxEnabled;
@synthesize sfxVolume = _sfxVolume;

- (id)initWithAudio:(__weak BTAudioManager*)audio {
    if ((self = [super init])) {
        _musicEnabled =
            [[RABoolValue alloc] initWithValue:[self boolForKey:MUSIC_ENABLED defaultValue:YES]];
        _musicVolume =
            [[RAFloatValue alloc] initWithValue:[self floatForKey:MUSIC_VOLUME defaultValue:1]];
        _sfxEnabled =
            [[RABoolValue alloc] initWithValue:[self boolForKey:SFX_ENABLED defaultValue:YES]];
        _sfxVolume =
            [[RAFloatValue alloc] initWithValue:[self floatForKey:MUSIC_VOLUME defaultValue:1]];

        [audio.musicControls setMuted:!_musicEnabled.value];
        [_musicEnabled connectSlot:^(BOOL musicEnabled) {
            [audio.musicControls setMuted:!musicEnabled];
            [self setBool:musicEnabled forKey:MUSIC_ENABLED];
        }];

        [audio.musicControls setVolume:_musicVolume.value];
        [_musicVolume connectSlot:^(float musicVolume) {
            [audio.musicControls setVolume:musicVolume];
            [self setFloat:musicVolume forKey:MUSIC_VOLUME];
        }];

        [audio.sfxControls setMuted:!_sfxEnabled.value];
        [_sfxEnabled connectSlot:^(BOOL sfxEnabled) {
            [audio.sfxControls setMuted:!sfxEnabled];
            [self setBool:sfxEnabled forKey:SFX_ENABLED];
        }];

        [audio.sfxControls setVolume:_sfxVolume.value];
        [_sfxVolume connectSlot:^(float sfxVolume) {
            [audio.sfxControls setVolume:sfxVolume];
            [self setFloat:sfxVolume forKey:SFX_VOLUME];
        }];
    }

    return self;
}

@end
