//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMovieResourceLayer.h"
#import "BTMovieResourceKeyframe.h"
#import "GDataXMLNode+BTExtensions.h"
#import "BTDeviceType.h"
#import "BTApp.h"

@interface BTMovieResourceLayer ()
- (void)buildKeyframeSymbolMap;
@end

@implementation BTMovieResourceLayer

- (id)initWithXml:(GDataXMLElement*)layerEl {
    if ((self = [super init])) {
        keyframes = [[NSMutableArray alloc] init];
        name = [layerEl stringAttribute:@"name"];

        int kfIndex = 0;
        for (GDataXMLElement* frameEl in [layerEl elementsForName:@"kf"]) {
            BTMovieResourceKeyframe* kf = [[BTMovieResourceKeyframe alloc] initWithIndex:kfIndex
                                                                                     xml:frameEl];
            [keyframes addObject:kf];
            kfIndex += kf->duration;
        }

        [self buildKeyframeSymbolMap];
    }

    return self;
}

- (id)initFlipbookNamed:(NSString*)animName xml:(GDataXMLElement*)layerEl {
    if ((self = [super init])) {
        keyframes = [[NSMutableArray alloc] init];
        name = [layerEl stringAttribute:@"name"];

        int kfIndex = 0;
        for (GDataXMLElement* frameEl in [layerEl elementsForName:@"kf"]) {
            BTMovieResourceKeyframe* kf = [[BTMovieResourceKeyframe alloc] initFlipbookNamed:animName
                                                                                   withIndex:kfIndex
                                                                                         xml:frameEl];
            [keyframes addObject:kf];
            kfIndex += kf->duration;
        }

        [self buildKeyframeSymbolMap];
    }

    return self;
}

- (void)buildKeyframeSymbolMap {
    // Build a mapping of symbol names -> keyframe indices
    keyframesForSymbol = [[NSMutableDictionary alloc] init];
    int kfnum = 0;
    for (BTMovieResourceKeyframe* kf in keyframes) {
        id key = OOONilToNSNull(kf->libraryItem);
        NSMutableArray* symbolIndices = [keyframesForSymbol objectForKey:key];
        if (symbolIndices == nil) {
            symbolIndices = [[NSMutableArray alloc] init];
            [keyframesForSymbol setObject:symbolIndices forKey:key];
        }
        [symbolIndices addObject:@(kfnum)];
        kfnum++;
    }
}

- (int)numFrames {
    BTMovieResourceKeyframe* lastKf = [keyframes lastObject];
    return lastKf->index + lastKf->duration;
}

@end
