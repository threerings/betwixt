//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPTextField.h"

@interface SPTextField (BTExtensions)

- (id)initWithFormat:(NSString*)text, ... NS_FORMAT_FUNCTION(1, 2);

/// Layout the text with the given width and height, and match the hit area
/// to the text area
- (void)autoSizeText:(NSString*)text maxWidth:(float)maxWidth maxHeight:(float)maxHeight;
- (void)autoSizeText:(NSString*)text maxWidth:(float)maxWidth;
- (void)autoSizeText:(NSString*)text;

@end
