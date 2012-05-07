//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTSoundResource.h"
#import "BTResourceFactory.h"
#import "BTSoundType.h"
#import "GDataXMLNode+BetwixtExtensions.h"
#import "BTApp.h"
#import "BTResourceManager.h"

@interface BTSoundFactory : NSObject <BTResourceFactory>
@end

@implementation BTSoundResource

@synthesize sound = _sound;
@synthesize type = _type;
@synthesize volume = _volume;
@synthesize pan = _pan;

+ (id<BTResourceFactory>)sharedFactory {
    static BTSoundFactory* instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[BTSoundFactory alloc] init];
        }
    }
    return instance;
}

+ (BTSoundResource*)require:(NSString*)name {
    return [BTApp.resourceManager requireResource:name ofType:[BTSoundResource class]];
}

- (id)initWithXml:(GDataXMLElement*)xml {
    if ((self = [super init])) {
        NSString* filename = [BTApp resourcePathFor:[xml stringAttribute:@"filename"]];
        _sound = [SPSound soundWithContentsOfFile:filename];
        _type = [xml enumAttribute:@"type" type:[BTSoundType class] defaultVal:BTSoundType.SFX];
        _volume = [xml floatAttribute:@"volume" defaultVal:1];
        _pan = [xml floatAttribute:@"pan" defaultVal:0];
    }
    return self;
}

@end

@implementation BTSoundFactory

- (BTResource*)create:(GDataXMLElement*)xml {
    return [[BTSoundResource alloc] initWithXml:xml];
}

@end
