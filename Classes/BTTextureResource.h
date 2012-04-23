//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTResource.h"
#import "BTDisplayObjectCreator.h"

#define BT_TEXTURE_RESOURCE_NAME @"texture"

@protocol BTResourceFactory;
@class GDataXMLElement;

@interface BTTextureResource : BTResource<BTDisplayObjectCreator> {
@protected
    SPTexture* _texture;
    SPPoint* _offset;
}

@property (nonatomic,readonly) SPTexture* texture;
@property (nonatomic,readonly) SPPoint* offset;

+ (id<BTResourceFactory>)sharedFactory;
+ (BTTextureResource*)require:(NSString*)name;

- (id)initWithXml:(GDataXMLElement*)xml;
- (SPImage*)createImage;

@end
