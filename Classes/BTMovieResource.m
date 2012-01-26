//
//  Betwixt - Copyright 2012 Three Rings Design

#import "BTMovieResource.h"
#import "BTResourceFactory.h"
#import "GDataXMLNode+OOO.h"

@interface BTMovieResourceFactory : NSObject<BTResourceFactory>
@end

@interface BTMovieResourceKeyframe : NSObject{
@public
    int index, duration;
    SPMatrix *matrix;
    NSString *libraryItem;
}
@end
@implementation BTMovieResourceKeyframe

-initWithFrame:(GDataXMLElement*)frameEl {
    if (!(self = [super init])) return nil;
    index = [frameEl intAttribute:@"index"];
    duration = [frameEl intAttribute:@"duration" defaultVal:1];

    GDataXMLElement *symbolEl = [frameEl walkTo:@"elements/DOMSymbolInstance"];
    libraryItem = [symbolEl stringAttribute:@"libraryItemName"];

    GDataXMLElement *matrixEl = [symbolEl walkTo:@"matrix/Matrix"];
    matrix = [[SPMatrix alloc] initWithA:[matrixEl floatAttribute:@"a" defaultVal:1]
                                       b:[matrixEl floatAttribute:@"b" defaultVal:0]
                                       c:[matrixEl floatAttribute:@"c" defaultVal:0]
                                       d:[matrixEl floatAttribute:@"d" defaultVal:1]
                                      tx:[matrixEl floatAttribute:@"tx" defaultVal:0]
                                      ty:[matrixEl floatAttribute:@"ty" defaultVal:0]];
    return self;
}
@end

@interface BTMovieResourceLayer :NSObject {
@public
    NSString *name;
    NSMutableArray *keyframes;
}
@end
@implementation BTMovieResourceLayer
-initWithLayer:(GDataXMLElement*)layerEl {
    if (!(self = [super init])) return nil;
    keyframes = [[NSMutableArray alloc] init];
    name = [layerEl stringAttribute:@"name"];
    for (GDataXMLElement *frameEl in [[layerEl walkTo:@"frames"] elements]) {
        [keyframes addObject:[[BTMovieResourceKeyframe alloc] initWithFrame:frameEl]];
    }
    return self;
}
@end

@implementation BTMovieResource {
@public
    NSMutableArray *layers;
}

- (id)init {
    if (!(self = [super init])) return nil;
    layers = [[NSMutableArray alloc] init];
    return self;
}

+ (id<BTResourceFactory>)sharedFactory {
    static BTMovieResourceFactory *instance;
    @synchronized(self) {
        if (instance == nil) instance = [[BTMovieResourceFactory alloc] init];
    }
    return instance;
}

@synthesize name = _name;
@synthesize group = _group;

@end


@implementation BTMovieResourceFactory

- (id<BTResource>)create:(NSString *)name group:(NSString *)group xml:(GDataXMLElement *)xml {
    BTMovieResource *movie = [[BTMovieResource alloc] init];
    GDataXMLElement *layersEl = [xml walkTo:@"DOMSymbolItem/timeline/DOMTimeline/layers"];
    for (GDataXMLElement *layerEl in [layersEl elements]) {
        [movie->layers addObject:[[BTMovieResourceLayer alloc] initWithLayer:layerEl]];
    }
    return movie;
}

@end
