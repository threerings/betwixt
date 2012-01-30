//
// Betwixt - Copyright 2012 Three Rings Design

@class BTResource;
@class GDataXMLElement;

@protocol BTResourceFactory

- (BTResource *)create:(GDataXMLElement *)xml;

@end