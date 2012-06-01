//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPSoundChannel.h"
#import "SPALSoundChannel.h"

@interface SPSoundChannel (BTExtensions)

@property (nonatomic,readonly) BOOL supportsPitch;
@property (nonatomic,assign) float pitch;

@end

@interface SPALSoundChannel (BTExtensions)

@property (nonatomic,readonly) BOOL supportsPitch;
@property (nonatomic,assign) float pitch;

@end
