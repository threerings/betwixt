//
//  Betwixt - Copyright 2012 Three Rings Design

#import "BTTextureResource.h"

@class GDataXMLElement;

@interface BTTextureResource (package)
- (id)initFromAtlas:(SPTexture*)atlas withXml:(GDataXMLElement*)xml;
@end
