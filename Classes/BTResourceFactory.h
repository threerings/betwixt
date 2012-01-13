//
//  Betwixt - Copyright 2011 Three Rings Design

@class BTResource;
@class GDataXMLElement;

@protocol BTResourceFactory

- (BTResource *)create:(NSString *)name group:(NSString *) group xml:(GDataXMLElement *)xml;

@end