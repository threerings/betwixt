//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTTextureResource.h"
#import "BTResourceFactory.h"
#import "GDataXMLNode+Extensions.h"
#import "BTApp.h"
#import "BTResourceManager.h"
#import "SPRectangle+Extensions.h"

@interface BTTextureFactory : NSObject<BTResourceFactory>
@end

@implementation BTTextureResource

+ (id<BTResourceFactory>)sharedFactory {
    static BTTextureFactory* instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[BTTextureFactory alloc] init];
        }
    }
    return instance;
}

+ (BTTextureResource*)require:(NSString*)name {
    return [BTApp.app.resourceManager requireResource:name ofType:[BTTextureResource class]];
}

- (id)initWithXml:(GDataXMLElement*)xml {
    if (!(self = [super init])) return nil;
    NSString* filename = [BTApp.app resourcePathFor:[xml stringAttribute:@"filename"]];
    _texture = [[SPTexture alloc] initWithContentsOfFile:filename];
    _texture.repeat = [xml boolAttribute:@"repeat" defaultVal:NO];
    _offset = [xml pointAttribute:@"offset" defaultVal:[SPPoint pointWithX:0 y:0]];
    return self;
}

- (id)initFromAtlas:(SPTexture*)atlas withXml:(GDataXMLElement*)xml {
    if (!(self = [super init])) return nil;
    
    float scale = 1.0f / atlas.scale;
    
    SPRectangle* region = [xml rectangleAttribute:@"rect"];
    [region scaleBy:scale];
    _texture = [[SPTexture alloc] initWithRegion:region ofTexture:atlas];
    _offset = [[xml pointAttribute:@"offset" defaultVal:[SPPoint pointWithX:0 y:0]] scaleBy:scale];
    _name = [xml stringAttribute:@"name"];
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

@synthesize texture = _texture, offset = _offset;

@end

@implementation BTTextureFactory

- (BTResource*)create:(GDataXMLElement*)xml {
    return [[BTTextureResource alloc] initWithXml:xml];
}

@end
