//
// Betwixt - Copyright 2012 Three Rings Design

#import <Foundation/Foundation.h>

@class GDataXMLElement;

@interface BTMovieResourceKeyframe : NSObject {
@public
    int index, duration;
    float x, y, rotation, scaleX, scaleY;
    float pivotX, pivotY;
    NSString* libraryItem;
    NSString* label;
}

-initWithFrame:(GDataXMLElement*)frameEl;
-initFlipbookNamed:(NSString*)name withXml:(GDataXMLElement*)frameEl;

@end
