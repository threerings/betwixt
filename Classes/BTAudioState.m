//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTAudioState.h"

@implementation BTAudioState

@synthesize volume;
@synthesize pan;
@synthesize pitch;
@synthesize paused;
@synthesize muted;
@synthesize stopped;

+ (BTAudioState*)defaultState {
    return [[BTAudioState alloc] init];
}

+ (BTAudioState*)combine:(BTAudioState*)a with:(BTAudioState*)b {
    return [BTAudioState combine:a with:b into:[[BTAudioState alloc] init]];
}

+ (BTAudioState*)combine:(BTAudioState*)a with:(BTAudioState*)b into:(BTAudioState*)into {
    if (into == nil) {
        into = [[BTAudioState alloc] init];
    }
    into.volume = a.volume * b.volume;
    into.pan = (a.pan + b.pan) * 0.5f;
    into.pitch = a.pitch * b.pitch;
    into.paused = a.paused || b.paused;
    into.muted = a.muted || b.muted;
    into.stopped = a.stopped || b.stopped;
    return into;
}

- (id)init {
    if ((self = [super init])) {
        volume = 1;
        pitch = 1;
    }
    return self;
}

- (float)actualVolume {
    return (muted ? 0 : volume);
}


@end
