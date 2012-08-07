//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTSpriteObject.h"
#import "BTUpdatable.h"

@class RABoolValue;

extern NSString* const BTMovieFirstFrame;
extern NSString* const BTMovieLastFrame;

@interface BTMovie : SPSprite <SPAnimatable> {
@protected
    BOOL _goingToFrame;// If a call to gotoFrame is active
    int _pendingFrame;// Latest frame given to gotoFrame while _goingToFrame, or NO_FRAME if there isn't a queued frame move
    int _frame;// Last drawn frame
    int _stopFrame;// Frame on which playing stops, or NO_FRAME if we're looping or already stopped
    RABoolValue* _playing;
    float _playTime;// Time position of the playhead. Does not snap to frame boundaries.
    float _duration;// Length of the movie in seconds
    RAObjectSignal* _labelPassed;
    NSArray* _labels;// <NSArray<NSString>> by frame idx
    NSMutableArray* _layers;// <BTMovieLayer>
    __weak SPJuggler* _juggler;// The juggler advancing us if we're on the stage, or nil if we're not on the display list
    float _framerate;
}

// Fires when a frame containing a label is entered or passed in an update in the order of the
// labels in the movie. If the update is longer than the duration of the movie, each label is fired
// once, not once for each pass.
@property (nonatomic,readonly) RAObjectSignal* labelPassed;
@property (nonatomic,readonly) RABoolValue* playing;
@property (nonatomic,readonly) float duration;
@property (nonatomic,readonly) int frame;
@property (nonatomic,readonly) int frames;
@property (nonatomic,readonly) float framerate;

- (void)playOnce;
- (void)play;
- (void)stop;

- (void)playFromLabel:(NSString*)label;
- (void)playFromFrame:(int)frame;
- (void)playFromLabel:(NSString*)startLabel toLabel:(NSString*)stopLabel;
- (void)playFromLabel:(NSString*)startLabel toFrame:(int)stopFrame;
- (void)playFromFrame:(int)startFrame toLabel:(NSString*)stopLabel;
- (void)playFromFrame:(int)startFrame toFrame:(int)stopFrame;
- (void)gotoLabel:(NSString*)label;
- (void)gotoFrame:(int)frame;
- (void)playToLabel:(NSString*)label;
- (void)playToFrame:(int)frame;

/// Adds a loop to the BTMovie. When "endLabel" is passed, the movie
/// will loop back to "startLabel"
/// (Returns an RAConnection that can be used to cancel the loop.)
/// BTMovieResource will automatically create loops when it encounters frame labels
/// of the form loop_start*/loop_end* (where '*' is any string, including the empty string).
- (RAConnection*)addLoopWithStart:(NSString*)startLabel end:(NSString*)endLabel;

/// Fires when the given label is fired by labelPassed.
- (RAConnection*)monitorLabel:(NSString*)label withUnit:(RAUnitBlock)slot;

@end
