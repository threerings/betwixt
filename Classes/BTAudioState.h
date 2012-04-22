//
// Betwixt - Copyright 2012 Three Rings Design

@interface BTAudioState : NSObject

@property (nonatomic) float volume;
@property (nonatomic) float pan;
@property (nonatomic) BOOL paused;
@property (nonatomic) BOOL muted;
@property (nonatomic) BOOL stopped;
@property (nonatomic,readonly) float actualVolume;

+ (BTAudioState*)defaultState;
+ (BTAudioState*)combine:(BTAudioState*)a with:(BTAudioState*)b;
+ (BTAudioState*)combine:(BTAudioState*)a with:(BTAudioState*)b into:(BTAudioState*)into;

@end
