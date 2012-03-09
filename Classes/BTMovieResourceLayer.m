//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMovieResourceLayer.h"
#import "BTMovieResourceKeyframe.h"
#import "GDataXMLNode+Extensions.h"
#import "BTUtils.h"

@implementation BTMovieResourceLayer
- (id)initWithLayer:(GDataXMLElement*)layerEl {
    if (!(self = [super init])) return nil;
    keyframes = [[NSMutableArray alloc] init];
    name = [layerEl stringAttribute:@"name"];
    
    int kfIndex = 0;
    for (GDataXMLElement* frameEl in [layerEl elementsForName:@"kf"]) {
        BTMovieResourceKeyframe* kf = [[BTMovieResourceKeyframe alloc] initWithIndex:kfIndex 
                                                                                 xml:frameEl];
        [keyframes addObject:kf];
        kfIndex += kf->duration;
    }
    
    // Build a mapping of symbol names -> keyframe indices
    keyframesForSymbol = [[NSMutableDictionary alloc] init];
    int kfnum = 0;
    for (BTMovieResourceKeyframe* kf in keyframes) {
        id key = BTNilToNSNull(kf->libraryItem);
        NSMutableArray* symbolIndices = [keyframesForSymbol objectForKey:key];
        if (symbolIndices == nil) {
            symbolIndices = [[NSMutableArray alloc] init];
            [keyframesForSymbol setObject:symbolIndices forKey:key];
        }
        [symbolIndices addObject:[NSNumber numberWithInt:kfnum]];
        kfnum++;
    }
    
    return self;
}

- (id)initFlipbookNamed:(NSString*)animName withXml:(GDataXMLElement *)layerEl {
    if (!(self = [super init])) return nil;
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
    return self;
}

- (int)numFrames {
    BTMovieResourceKeyframe* lastKf = [keyframes lastObject];
    return lastKf->index + lastKf->duration;
}
@end
