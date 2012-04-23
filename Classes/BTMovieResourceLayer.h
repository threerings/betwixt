//
// Betwixt - Copyright 2012 Three Rings Design

@class GDataXMLElement;
@class BTDeviceType;

@interface BTMovieResourceLayer : NSObject {
@public
    NSString* name;
    NSMutableArray* keyframes;
    NSMutableDictionary* keyframesForSymbol; // Map<symbolName, Array<frame indices>>
}
- (id)initWithXml:(GDataXMLElement*)layerEl;
- (id)initFlipbookNamed:(NSString*)animName xml:(GDataXMLElement*)layerEl;

@property(nonatomic,readonly) int numFrames;
@end
