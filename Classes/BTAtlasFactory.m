//
//  Betwixt - Copyright 2012 Three Rings Design

#import "BTAtlasFactory.h"
#import "BTMultiResourceFactory.h"
#import "BTTextureResource+Package.h"
#import "GDataXMLNode+Extensions.h"
#import "BTApp.h"
#import "BTResourceManager.h"


@implementation BTAtlasFactory {
    SPTexture* _texture;
}

+ (id<BTMultiResourceFactory>)sharedFactory {
    static BTAtlasFactory* instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[BTAtlasFactory alloc] init];
        }
    }
    return instance;
}

- (NSArray*)create:(GDataXMLElement*)xml {
    NSMutableArray* textures = [[NSMutableArray alloc] init];
    SPTexture* atlas = [[SPTexture alloc] initWithContentsOfFile:[xml stringAttribute:@"file"]];
    for (GDataXMLElement* child in [xml elements]) {
        [textures addObject:[[BTTextureResource alloc] initFromAtlas:atlas withXml:child]];
    }
    return textures;
}
@end
