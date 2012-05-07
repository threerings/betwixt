//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTAudioManager.h"
#import "BTAudioControls.h"
#import "BTAudioChannel+Package.h"
#import "BTSoundResource.h"
#import "BTSoundType.h"
#import "BTAudioState.h"
#import "BTApp.h"

static const double SOUND_PLAYED_RECENTLY_DELTA = 1.0 / 20.0;

@interface BTAudioManager ()
- (void)playChannel:(BTAudioChannel*)channel state:(BTAudioState*)state;
@end

@implementation BTAudioManager

@synthesize masterControls = _masterControls;
@synthesize sfxControls = _sfxControls;
@synthesize musicControls = _musicControls;

- (id)init {
    if ((self = [super init])) {
        [SPAudioEngine start];
        _masterControls = [[BTAudioControls alloc] init];
        _sfxControls = [[BTAudioControls alloc] initWithParentControls:_masterControls];
        _musicControls = [[BTAudioControls alloc] initWithParentControls:_masterControls];
        _defaultState = [BTAudioState defaultState];
        _activeChannels = [[NSMutableArray alloc] init];
    }
    return self;
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
        if (channel.isPlaying) {
            BTAudioState* audioState = channel.controls.state;
            BOOL channelPaused = channel.isPaused;
            if (audioState.stopped) {
                [self stop:channel];
            } else if (audioState.paused && !channelPaused) {
                [self pause:channel];
            } else if (!audioState.paused && channelPaused) {
                [self resume:channel];
            } else if (!channelPaused) {
                channel->_spChannel.volume = audioState.actualVolume * channel.sound.volume;
            }
        }
        
        if (!channel.isPlaying) {
            hasStoppedChannels = YES;
        }
    }
    
    // Remove inactive channels
    if (hasStoppedChannels) {
        [_activeChannels = _activeChannels filter:^BOOL(BTAudioChannel* channel) {
            return channel.isPlaying;
        }];
    }
}

- (BTAudioChannel*)playSoundNamed:(NSString*)name 
                   parentControls:(BTAudioControls*)parentControls 
                             loop:(BOOL)loop {
    return [self playSound:[BTSoundResource require:name] parentControls:parentControls loop:loop];
}

- (BTAudioChannel*)playSoundNamed:(NSString*)name loop:(BOOL)loop {
    return [self playSoundNamed:name parentControls:nil loop:loop];
}

- (BTAudioChannel*)playSoundNamed:(NSString*)name {
    return [self playSoundNamed:name parentControls:nil loop:NO];
}

- (BTAudioChannel*)playSound:(BTSoundResource*)soundResource 
              parentControls:(BTAudioControls*)parentControls 
                        loop:(BOOL)loop {
    // get the appropriate parent controls
    if (parentControls == nil) {
        parentControls = [self getControlsForSoundType:soundResource.type];
    }
    
    // don't play the sound if its parent controls are stopped
    BTAudioState* audioState = [parentControls updateStateNow];
    if (audioState.stopped) {
        NSLog(@"Discarding sound '%@' (parent controls are stopped)", soundResource.name);
        return [[BTAudioChannel alloc] init];
    }
    
    // iterate the active channels to determine if this sound has been played
    // recently
    double timeNow = BTApp.timeNow;
    for (BTAudioChannel* activeChannel in _activeChannels) {
        if (activeChannel.isPlaying && activeChannel.sound == soundResource && 
            (timeNow - activeChannel->_startTime) < SOUND_PLAYED_RECENTLY_DELTA) {
            NSLog(@"Discarding sound '%@' (recently played)", soundResource.name);
            return [[BTAudioChannel alloc] init];
        }
    }
    
    // create the channel
    BTAudioChannel* channel = [[BTAudioChannel alloc] init];
    channel->_controls = [[BTAudioControls alloc] initWithParentControls:parentControls];
    channel->_sound = soundResource;
    channel->_startTime = timeNow;
    channel->_loop = loop;
    
    // start playing
    if (!audioState.paused) {
        [self playChannel:channel state:audioState];
    }
    
    [_activeChannels addObject:channel];
    return channel;
}

- (void)playChannel:(BTAudioChannel*)channel state:(BTAudioState*)state {
    [channel playWithState:state];
}

- (void)stopAllSounds {
    for (BTAudioChannel* channel in _activeChannels) {
        [self stop:channel];
    }
    [_activeChannels removeAllObjects];
}

- (void)stop:(BTAudioChannel*)channel {
    [channel stop];
}

- (void)pause:(BTAudioChannel*)channel {
    if (channel.isPlaying && !channel.isPaused) {
        [channel->_spChannel pause];
    }
}

- (void)resume:(BTAudioChannel*)channel {
    if (channel.isPlaying && channel.isPaused) {
        [channel->_spChannel play];
    }
}

- (void)shutdown {
    [self stopAllSounds];
    [SPAudioEngine stop];
}

@end
