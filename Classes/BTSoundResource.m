//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTSoundResource.h"
#import "BTResourceFactory.h"
#import "BTSoundType.h"
#import "GDataXMLNode+BTExtensions.h"
#import "BTApp.h"
#import "BTResourceManager.h"

@interface BTSoundResourceFactory : NSObject <BTResourceFactory>
@end

@implementation BTSoundResource

@synthesize sound = _sound;
@synthesize type = _type;
@synthesize volume = _volume;
@synthesize pan = _pan;

+ (id<BTResourceFactory>)sharedFactory {
    return OOO_SINGLETON([[BTSoundResourceFactory alloc] init]);
}

+ (BTSoundResource*)require:(NSString*)name {
    return [BTApp.resourceManager requireResource:name ofType:[BTSoundResource class]];
}

- (id)initWithXml:(GDataXMLElement*)xml {
    if ((self = [super init])) {
        NSString* filename = [BTApp requireResourcePathFor:[xml stringAttribute:@"filename"]];
        _sound = [SPSound soundWithContentsOfFile:filename];
        _type = [xml enumAttribute:@"type" type:[BTSoundType class] defaultVal:BTSoundType.SFX];
        _volume = [xml floatAttribute:@"volume" defaultVal:1];
        _pan = [xml floatAttribute:@"pan" defaultVal:0];
    }
    return self;
}

@end

@implementation BTSoundResourceFactory

- (BTResource*)create:(GDataXMLElement*)xml {
    return [[BTSoundResource alloc] initWithXml:xml];
}

@end
