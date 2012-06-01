//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTAudioManager+Package.h"
#import "BTAudioControls.h"
#import "BTAudioChannel+Package.h"
#import "BTSoundResource.h"
#import "BTSoundType.h"
#import "BTAudioState.h"
#import "BTAudioSettings.h"
#import "BTApp.h"

static const double SOUND_PLAYED_RECENTLY_DELTA = 1.0 / 20.0;

@implementation BTAudioManager

@synthesize masterControls = _masterControls;
@synthesize sfxControls = _sfxControls;
@synthesize musicControls = _musicControls;
@synthesize settings = _settings;

- (id)init {
    if ((self = [super init])) {
        _masterControls = [[BTAudioControls alloc] init];
        _sfxControls = [[BTAudioControls alloc] initWithParentControls:_masterControls];
        _musicControls = [[BTAudioControls alloc] initWithParentControls:_masterControls];
        _defaultState = [BTAudioState defaultState];
        _activeChannels = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setup {
    [SPAudioEngine start];
    _settings = [[BTAudioSettings alloc] initWithAudio:self];
}

- (void)shutdown {
    [self stopAllSounds];
    [SPAudioEngine stop];
}

- (BTAudioControls*)getControlsForSoundType:(BTSoundType*)type {
    if (type == BTSoundType.SFX) {
        return _sfxControls;
    } else if (type == BTSoundType.MUSIC) {
        return _musicControls;
    } else {
        return nil;
    }
}

- (void)update:(float)dt {
    [_masterControls update:dt parentState:_defaultState];
    
    // update all playing sound channels
    BOOL hasStoppedChannels = NO;
    for (BTAudioChannel* channel in _activeChannels) {
        [channel update];
        if (!channel.isPlaying) {
            hasStoppedChannels = YES;
        }
    }
    
    // Remove inactive channels
    if (hasStoppedChannels) {
        _activeChannels = [_activeChannels filter:^BOOL(BTAudioChannel* channel) {
            return channel.isPlaying;
        }];
    }
}

- (BTAudioChannel*)playSoundNamed:(NSString*)name
                     initialState:(BTAudioState*)initialState
                   parentControls:(BTAudioControls*)parentControls 
                             loop:(BOOL)loop {
    return [self playSound:[BTSoundResource require:name] initialState:initialState 
            parentControls:parentControls loop:loop];
}

- (BTAudioChannel*)playSoundNamed:(NSString*)name loop:(BOOL)loop {
    return [self playSound:[BTSoundResource require:name] initialState:nil parentControls:nil 
                      loop:loop];
}

- (BTAudioChannel*)playSoundNamed:(NSString*)name {
    return [self playSound:[BTSoundResource require:name] initialState:nil parentControls:nil 
                      loop:NO];
}

- (BTAudioChannel*)playSoundNamed:(NSString*)name initialState:(BTAudioState*)initialState {
    return [self playSound:[BTSoundResource require:name] initialState:initialState 
            parentControls:nil loop:NO];
}

- (BTAudioChannel*)playSound:(BTSoundResource*)soundResource 
                initialState:(BTAudioState*)initialState
              parentControls:(BTAudioControls*)parentControls 
                        loop:(BOOL)loop {
    // get the appropriate parent controls
    if (parentControls == nil) {
        parentControls = [self getControlsForSoundType:soundResource.type];
    }
    
    // don't play the sound if its initial state is stopped
    if (initialState != nil && initialState.stopped) {
        NSLog(@"Discarding sound '%@' (initialState is stopped)", soundResource.name);
        return [[BTAudioChannel alloc] init];
    }
    
    // don't play the sound if its parent controls are stopped
    BTAudioState* parentState = [parentControls updateStateNow];
    if (parentState.stopped) {
        NSLog(@"Discarding sound '%@' (parent controls are stopped)", soundResource.name);
        return [[BTAudioChannel alloc] init];
    }
    
    // iterate the active channels to determine if this sound has been played
    // recently
    double timeNow = BTApp.timeNow;
    for (BTAudioChannel* activeChannel in _activeChannels) {
        if (activeChannel.isPlaying && activeChannel.sound == soundResource && 
            (timeNow - activeChannel.startTime) < SOUND_PLAYED_RECENTLY_DELTA) {
            NSLog(@"Discarding sound '%@' (recently played)", soundResource.name);
            return [[BTAudioChannel alloc] init];
        }
    }
    
    if (initialState == nil) {
        initialState = [[BTAudioState alloc] init];
    }
    
    // create the channel
    BTAudioChannel* channel = [[BTAudioChannel alloc] initWithControls:[parentControls createChild:initialState] 
                                                                 sound:soundResource 
                                                             startTime:timeNow 
                                                                  loop:loop];
    
    // start playing
    [channel playWithState:[BTAudioState combine:parentState with:initialState]];
    [_activeChannels addObject:channel];
    return channel;
}

- (void)stopAllSounds {
    for (BTAudioChannel* channel in _activeChannels) {
        [channel stop];
    }
    [_activeChannels removeAllObjects];
}

@end
