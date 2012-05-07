//
// Betwixt - Copyright 2012 Three Rings Design

@interface BTMovieResourceLayer : NSObject {
@public
    NSString* name;
    NSMutableArray* keyframes;
    NSMutableDictionary* keyframesForSymbol; // Map<symbolName, Array<frame indices>>
}

@property (nonatomic,readonly) int numFrames;

- (id)initWithXml:(GDataXMLElement*)layerEl;
- (id)initFlipbookNamed:(NSString*)animName xml:(GDataXMLElement*)layerEl;

@end
