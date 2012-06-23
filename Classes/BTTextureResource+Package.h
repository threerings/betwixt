//
//  Betwixt - Copyright 2012 Three Rings Design

#import "BTTextureResource.h"

@class GDataXMLElement;

@interface BTTextureResource (package)
- (id)initFromAtlas:(SPTexture*)atlas withAtlasFilename:(NSString*)filename withXml:(GDataXMLElement*)xml;
@end
