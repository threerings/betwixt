//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPSoundChannel+BTExtensions.h"

#import <OpenAL/al.h>
#import <OpenAL/alc.h>

@implementation SPSoundChannel (BTExtensions)

- (BOOL)supportsPitch {
    return NO;
}

- (float)pitch {
    NSLog(@"pitch is not supported by %@", [self class]);
    return 1.0f;
}

- (void)setPitch:(float)pitch {
    NSLog(@"pitch is not supported by %@", [self class]);
}

@end

@implementation SPALSoundChannel (BTExtensions)

- (BOOL)supportsPitch {
    return YES;
}

- (float)pitch {
    float pitch;
    alGetSourcef(mSourceID, AL_PITCH, &pitch);
    return pitch;
}

- (void)setPitch:(float)pitch {
    alSourcef(mSourceID, AL_PITCH, pitch);
}

@end
