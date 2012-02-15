//
//  Betwixt - Copyright 2012 Three Rings Design

#import "BTTextureResource.h"

#import "GDataXMLNode+Extensions.h"

@interface BTTextureResource (package)
- (id)initFromAtlas:(SPTexture*)atlas withXml:(GDataXMLElement*)xml;
@end
