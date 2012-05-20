//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPBitmapFont.h"

@interface SPBitmapFont (BTExtensions)

- (SPPoint*)getSizeForText:(NSString*)text fontSize:(float)fontSize kerning:(BOOL)kerning;
- (SPPoint*)getSizeForText:(NSString*)text fontSize:(float)fontSize kerning:(BOOL)kerning 
                  maxWidth:(float)maxWidth;

/// Lays out text on a single line
- (SPDisplayObject*)createDisplayObjectWithText:(NSString*)text fontSize:(float)size 
                                          color:(uint)color kerning:(BOOL)kerning;

/// Lays out text using a maximum width
- (SPDisplayObject*)createDisplayObjectWithMaxWidth:(float)maxWidth 
                                               text:(NSString*)text 
                                           fontSize:(float)size
                                              color:(uint)color 
                                             hAlign:(SPHAlign)hAlign
                                            kerning:(BOOL)kerning;

/// Lays out text using a maximum width and height
- (SPDisplayObject*)createDisplayObjectWithMaxWidth:(float)maxWidth
                                          maxHeight:(float)maxHeight
                                               text:(NSString*)text 
                                           fontSize:(float)size
                                              color:(uint)color 
                                             hAlign:(SPHAlign)hAlign
                                            kerning:(BOOL)kerning;


@end
