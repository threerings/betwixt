//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTSprite.h"
#import "BTUpdatable.h"

@class RABoolValue;

extern NSString * const BTMovieFirstFrame;
extern NSString * const BTMovieLastFrame;

@interface BTMovie : SPSprite <SPAnimatable>

- (void)loopFromLabel:(NSString*)label;
- (void)loopFromFrame:(int)frame;
- (void)playFromLabel:(NSString*)startLabel toLabel:(NSString*)stopLabel;
- (void)playFromLabel:(NSString*)startLabel toFrame:(int)stopFrame;
- (void)playFromFrame:(int)startFrame toLabel:(NSString*)stopLabel;
- (void)playFromFrame:(int)startFrame toFrame:(int)stopFrame;
- (void)gotoLabel:(NSString*)label;
- (void)gotoFrame:(int)frame;
- (void)playToLabel:(NSString*)label;
- (void)playToFrame:(int)frame;

// Fires when the given label is fired by labelPassed.
- (RAConnection*)monitorLabel:(NSString*)label withUnit:(RAUnitBlock)slot;

// Fires when a frame containing a label is entered or passed in an update in the order of the
// labels in the movie. If the update is longer than the duration of the movie, each label is fired
// once, not once for each pass.
@property(nonatomic,readonly) RAObjectSignal* labelPassed;
@property(nonatomic,readonly) RABoolValue* playing;
@property(nonatomic,readonly) float duration;
@property(nonatomic,readonly) int frame;
@property(nonatomic,readonly) int frames;
@end
