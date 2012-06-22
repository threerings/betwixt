//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTTextureResource.h"
#import "BTResourceFactory.h"
#import "GDataXMLNode+BTExtensions.h"
#import "BTApp.h"
#import "BTResourceManager.h"
#import "SPRectangle+BTExtensions.h"

@interface BTTextureResourceFactory : NSObject<BTResourceFactory>
@end

@implementation BTTextureResource

@synthesize texture = _texture;
@synthesize offset = _offset;

+ (id<BTResourceFactory>)sharedFactory {
    return OOO_SINGLETON([[BTTextureResourceFactory alloc] init]);
}

+ (BTTextureResource*)require:(NSString*)name {
    return [BTApp.resourceManager requireResource:name ofType:[BTTextureResource class]];
}

+ (SPImage*)newImage:(NSString*)name {
    return [[BTTextureResource require:name] createImage];
}

- (id)initWithXml:(GDataXMLElement*)xml {
    if ((self = [super init])) {
        NSString* filename = [BTApp requireResourcePathFor:[xml stringAttribute:@"filename"]];
        _texture = [[SPTexture alloc] initWithContentsOfFile:filename];
        _texture.repeat = [xml boolAttribute:@"repeat" defaultVal:NO];
        _offset = [xml pointAttribute:@"offset" defaultVal:[SPPoint pointWithX:0 y:0]];
    }
    return self;
}

- (id)initFromAtlas:(SPTexture*)atlas withXml:(GDataXMLElement*)xml {
    if ((self = [super init])) {
        float scale = 1.0f / atlas.scale;
        
        SPRectangle* region = [xml rectangleAttribute:@"rect"];
        [region scaleBy:scale];
        _texture = [[SPTexture alloc] initWithRegion:region ofTexture:atlas];
        _offset = [[xml pointAttribute:@"offset" defaultVal:[SPPoint pointWithX:0 y:0]] scaleBy:scale];
        _name = [xml stringAttribute:@"name"];
    }
    return self;
}

- (SPDisplayObject*)createDisplayObject {
    SPSprite* holder = [[SPSprite alloc] init];
    SPImage* img = [[SPImage alloc] initWithTexture:_texture];
    img.x = _offset.x;
    img.y = _offset.y;
    [holder addChild:img];
    return holder;
}

- (SPImage*)createImage {
    SPImage* img = [[SPImage alloc] initWithTexture:_texture];
    img.pivotX = -_offset.x;
    img.pivotY = -_offset.y;
    return img;
}

@end

@implementation BTTextureResourceFactory

- (BTResource*)create:(GDataXMLElement*)xml {
    return [[BTTextureResource alloc] initWithXml:xml];
}

@end
