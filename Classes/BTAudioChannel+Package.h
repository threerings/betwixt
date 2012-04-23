//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTAudioChannel.h"

@class BTAudioState;

@interface BTAudioChannel (package)
- (void)playWithState:(BTAudioState*)state;
- (void)stop;
- (void)handleComplete;
@end