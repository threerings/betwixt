//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTAudioChannel.h"

@class BTAudioState;
@class BTAudioControls;
@class BTSoundResource;

@interface BTAudioChannel (package)
- (id)initWithControls:(BTAudioControls*)controls sound:(BTSoundResource*)sound startTime:(double)startTime loop:(BOOL)loop;
- (void)playWithState:(BTAudioState*)state;
- (void)setVolume:(float)volume;
- (void)stop;
- (void)pause;
- (void)resume;
- (void)handleComplete;
@end