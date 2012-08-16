//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTResource.h"
#import "BTDisplayObjectCreator.h"

#define BT_TEXTURE_RESOURCE_NAME @"texture"

@protocol BTResourceFactory;
@class BTBitmap;
@class GDataXMLElement;

@interface BTTextureResource : BTResource<BTDisplayObjectCreator> {
@protected
    SPTexture* _texture;
    SPPoint* _offset;

    NSString* _filename;
    SPRectangle* _region;
}

@property (nonatomic,readonly) SPTexture* texture;
@property (nonatomic,readonly) SPPoint* offset;

+ (id<BTResourceFactory>)sharedFactory;
+ (BTTextureResource*)require:(NSString*)name;
+ (SPImage*)newImage:(NSString*)name;

- (id)initWithXml:(GDataXMLElement*)xml;
- (SPImage*)createImage;

- (UIImage*)createUIImage;
- (BTBitmap*)createBitmap;

@end
