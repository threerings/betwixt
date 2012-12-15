//
//  Betwixt - Copyright 2012 Three Rings Design

#import "BTTextureGroupFactory.h"
#import "BTMultiResourceFactory.h"
#import "BTTextureResource+Package.h"
#import "GDataXMLNode+BTExtensions.h"
#import "GDataXMLException.h"
#import "BTApp.h"
#import "BTResourceManager.h"
#import "BTDeviceType.h"

@implementation BTTextureGroupFactory

+ (id<BTMultiResourceFactory>)sharedFactory {
    return OOO_SINGLETON([[BTTextureGroupFactory alloc] init]);
}

- (NSArray*)create:(GDataXMLElement*)xml {
    NSArray* groupElements = [xml elementsForName:@"textureGroup"];
    if (groupElements.count <= 0) {
        return @[];
    }
    
    // sort the textureGroups by scaleFactor
    [groupElements sortedArrayUsingComparator:^NSComparisonResult(GDataXMLElement* a, GDataXMLElement* b) {
        int scaleFactorA = [a intAttribute:@"scaleFactor"];
        int scaleFactorB = [b intAttribute:@"scaleFactor"];
        return OOOCompareInts(scaleFactorA, scaleFactorB);
    }];

    // find the group with the highest scale factor <= our desired scale factor, if one exists
    GDataXMLElement* theGroup = nil;
    for (GDataXMLElement* groupXml in groupElements.reverseObjectEnumerator) {
        if ([groupXml intAttribute:@"scaleFactor"] <= [SPStage contentScaleFactor]) {
            theGroup = groupXml;
            break;
        }
    }

    if (theGroup == nil) {
        theGroup = groupElements[0];
    }

    NSMutableArray* textures = [[NSMutableArray alloc] init];
    for (GDataXMLElement* atlasXml in [theGroup elementsForName:@"atlas"]) {
        NSString* filename = [BTApp resourcePathFor:[atlasXml stringAttribute:@"file"]];
        if (filename == nil) {
            @throw [GDataXMLException withElement:xml reason:@"Missing texture atlas: %@", filename];
        }
        SPTexture* atlas = [[SPTexture alloc] initWithContentsOfFile:filename];
        for (GDataXMLElement* child in [atlasXml elements]) {
            [textures addObject:[[BTTextureResource alloc] initFromAtlas:atlas withAtlasFilename:filename withXml:child]];
        }
    }

    return textures;
}
@end
