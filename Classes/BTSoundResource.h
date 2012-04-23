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
}

@property (nonatomic,readonly) SPSound* sound;
@property (nonatomic,readonly) BTSoundType* type;
@property (nonatomic,readonly) float volume;
@property (nonatomic,readonly) float pan;

+ (id<BTResourceFactory>)sharedFactory;
+ (BTSoundResource*)require:(NSString*)name;

@end
