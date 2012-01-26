//
//  Betwixt - Copyright 2011 Three Rings Design

@class BTResource;
@class GDataXMLElement;

@protocol BTResourceFactory

- (BTResource *)create:(GDataXMLElement *)xml;

@end