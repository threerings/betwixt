//
// Betwixt - Copyright 2012 Three Rings Design

#import <Foundation/Foundation.h>

@class GDataXMLElement;

@interface BTMovieResourceLayer : NSObject {
@public
    NSString* name;
    NSMutableArray* keyframes;
}
-initWithLayer:(GDataXMLElement*)layerEl;
-initFlipbookNamed:(NSString*)name withXml:(GDataXMLElement*)layerEl;

@property(nonatomic,readonly) int frames;
@end
