//
// gulp - Copyright 2011 Three Rings Design

@class GUResource;
@class GDataXMLElement;

@protocol GUResourceFactory

- (GUResource *)create:(NSString *)name group:(NSString *) group xml:(GDataXMLElement *)xml;

@end