//
// Betwixt - Copyright 2012 Three Rings Design

@interface BTAudioState : NSObject

@property (nonatomic,assign) float volume;
@property (nonatomic,assign) float pan;
@property (nonatomic,assign) float pitch;
@property (nonatomic,assign) BOOL paused;
@property (nonatomic,assign) BOOL muted;
@property (nonatomic,assign) BOOL stopped;
@property (nonatomic,readonly) float actualVolume;

+ (BTAudioState*)defaultState;
+ (BTAudioState*)combine:(BTAudioState*)a with:(BTAudioState*)b;
+ (BTAudioState*)combine:(BTAudioState*)a with:(BTAudioState*)b into:(BTAudioState*)into;

@end
