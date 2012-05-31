//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTResource.h"

#define BT_FONT_RESOURCE_NAME @"font"

@protocol BTResourceFactory;
@class GDataXMLElement;

@interface BTFontResource : BTResource

+ (id<BTResourceFactory>)sharedFactory;
+ (BTFontResource*)require:(NSString*)name;

- (id)initWithXml:(GDataXMLElement*)xml;

@end
