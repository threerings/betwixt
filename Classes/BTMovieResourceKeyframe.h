//
// Betwixt - Copyright 2012 Three Rings Design

#import <Foundation/Foundation.h>

@class GDataXMLElement;

@interface BTMovieResourceKeyframe : NSObject {
@public
    int index, duration;
    float x, y, rotation, scaleX, scaleY;
    NSString *libraryItem;
}

-initWithFrame:(GDataXMLElement*)frameEl;

@end
