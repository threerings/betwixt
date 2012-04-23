//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTAudioChannel.h"
#import "BTSoundResource.h"
#import "BTAudioControls.h"

BTAudioControls* GetDummyControls ();
BTAudioControls* GetDummyControls () {
    static BTAudioControls* gDummyControls = nil;
    if (gDummyControls == nil) {
        gDummyControls = [[BTAudioControls alloc] init];
    }
    return gDummyControls;
}

@implementation BTAudioChannel

@synthesize completed = _completed;

- (id)init {
    if ((self = [super init])) {
        _completed = [[RAUnitSignal alloc] init];
    }
    return self;
}

- (BOOL)isPlaying {
    return (_sound != nil);
}

- (BOOL)isPaused {
    return (_sound != nil && _spChannel == nil);
}

- (BTAudioControls*)controls {
    return (_controls != nil ? _controls : GetDummyControls());
}

@end
