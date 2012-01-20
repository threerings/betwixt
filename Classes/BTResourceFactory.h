//
//  Betwixt - Copyright 2011 Three Rings Design

@protocol BTResource;
@class GDataXMLElement;

@protocol BTResourceFactory

- (id<BTResource>)create:(NSString *)name group:(NSString *) group xml:(GDataXMLElement *)xml;

@end