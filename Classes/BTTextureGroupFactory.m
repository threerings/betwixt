//
//  Betwixt - Copyright 2012 Three Rings Design

#import "BTTextureGroupFactory.h"
#import "BTMultiResourceFactory.h"
#import "BTTextureResource+Package.h"
#import "GDataXMLNode+BetwixtExtensions.h"
#import "GDataXMLException.h"
#import "BTApp.h"
#import "BTResourceManager.h"
#import "BTDeviceType.h"


@implementation BTTextureGroupFactory {
    NSArray* _targetDevicePrefs;
}

+ (id<BTMultiResourceFactory>)sharedFactory {
    static BTTextureGroupFactory* instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[BTTextureGroupFactory alloc] init];
        }
    }
    return instance;
}

- (id)init {
    if (!(self = [super init])) {
        return nil;
    }
    
    // Build a list of device types, in the order that we prefer textures:
    // - textures for our device
    // - textures for lower-res devices
    // - textures for higher-res devices
    _targetDevicePrefs = [[BTDeviceType values] sortedArrayUsingComparator:^NSComparisonResult(BTDeviceType* a, BTDeviceType* b) {
        if (a == BTApp.deviceType) {
            return -1;
        } else if (b == BTApp.deviceType) {
            return 1;
        } else {
            return OOOCompareInts(a.screenWidth * a.screenHeight, b.screenWidth * b.screenHeight);
        }
    }];
    
    return self;
}

- (NSArray*)create:(GDataXMLElement*)xml {
    NSMutableArray* textures = [[NSMutableArray alloc] init];
    
    GDataXMLElement* theGroup = nil;
    NSArray* groupElements = [xml elementsForName:@"textureGroup"];
    if (groupElements.count > 2) {
        @throw [GDataXMLException withElement:xml 
                                       reason:@"Too many texture groups (expected no more than 2)"];
    }
    
    for (GDataXMLElement* groupXml in groupElements) {
        BOOL retina = [groupXml boolAttribute:@"retina"];
        if (retina == BTApp.deviceType.retina) {
            theGroup = groupXml;
            break;
        }
    }
    if (theGroup == nil) {
        @throw [GDataXMLException withElement:xml reason:@"Missing texture group for density of %@", BTApp.deviceType.name];
    }
    
    if (theGroup != nil) {
        for (GDataXMLElement* atlasXml in [theGroup elementsForName:@"atlas"]) {
            NSString* filename = [atlasXml stringAttribute:@"file"];
            NSString* filepath = [BTApp resourcePathFor:filename];
            if (filepath == nil) {
                @throw [GDataXMLException withElement:xml reason:@"Missing texture atlas: %@", filename];
            }
            SPTexture* atlas = [[SPTexture alloc] initWithContentsOfFile:filepath];
            for (GDataXMLElement* child in [atlasXml elements]) {
                [textures addObject:[[BTTextureResource alloc] initFromAtlas:atlas withXml:child]];
            }
        }
    }
    
    return textures;
}
@end
