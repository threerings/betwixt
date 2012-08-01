//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTResource.h"

#define BT_SOUND_RESOURCE_NAME @"sound"

@protocol BTResourceFactory;
@class BTSoundType;

@interface BTSoundResource : BTResource {
@protected
    SPSound* _sound;
    BTSoundType* _type;
    float _volume;
    float _pan;

    BOOL _randomizePitch;
    float _pitchShiftMin;
    float _pitchShiftMax;
}

@property (nonatomic,readonly) SPSound* sound;
@property (nonatomic,readonly) BTSoundType* type;
@property (nonatomic,readonly) float volume;
@property (nonatomic,readonly) float pan;
@property (nonatomic,readonly) BOOL randomizePitch;
@property (nonatomic,readonly) float pitchShiftMin;
@property (nonatomic,readonly) float pitchShiftMax;

+ (id<BTResourceFactory>)sharedFactory;
+ (BTSoundResource*)require:(NSString*)name;

@end
