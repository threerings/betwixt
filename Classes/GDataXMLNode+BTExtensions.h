//
// Betwixt - Copyright 2012 Three Rings Design

@interface GDataXMLElement (BTExtensions)

- (SPPoint*)pointAttribute:(NSString*)name defaultVal:(SPPoint*)defaultVal;
- (SPPoint*)pointAttribute:(NSString *)name;
- (SPRectangle*)rectangleAttribute:(NSString*)name defaultVal:(SPRectangle*)defaultVal;
- (SPRectangle*)rectangleAttribute:(NSString*)name;

@end
