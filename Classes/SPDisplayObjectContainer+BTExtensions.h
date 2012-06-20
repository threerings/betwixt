//
// Betwixt - Copyright 2012 Three Rings Design

@interface SPDisplayObjectContainer (BTExtensions)

- (SPDisplayObject*)childByFormatName:(NSString*)format, ... NS_FORMAT_FUNCTION(1, 2);

@end
