//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPBitmapFont.h"

@interface SPBitmapFont (BTExtensions)

/// Lays out text using a maximum width and height
- (SPDisplayObject*)createDisplayObjectWithMaxWidth:(float)maxWidth maxHeight:(float)maxHeight 
                                               text:(NSString*)text fontSize:(float)size 
                                              color:(uint)color hAlign:(SPHAlign)hAlign
                                             border:(BOOL)border kerning:(BOOL)kerning;


@end
