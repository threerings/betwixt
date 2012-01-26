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
@implementation BTMovieResourceKeyframe @end

@interface BTMovieResourceLayer :NSObject {
@public
    NSString *name;
    NSMutableArray *keyframes;
}
@end
@implementation BTMovieResourceLayer @end

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
        BTMovieResourceLayer *layer = [[BTMovieResourceLayer alloc] init];
        layer->keyframes = [[NSMutableArray alloc] init];
        layer->name = [layerEl stringAttribute:@"name"];
        for (GDataXMLElement *frameEl in [[layerEl walkTo:@"frames"] elements]) {
            BTMovieResourceKeyframe *keyframe = [[BTMovieResourceKeyframe alloc] init];
            keyframe->index = [frameEl intAttribute:@"index"];
            keyframe->duration = [frameEl intAttribute:@"duration" defaultVal:1];
            GDataXMLElement *symbolEl = [frameEl walkTo:@"elements/DOMSymbolInstance"];
            keyframe->libraryItem = [symbolEl stringAttribute:@"libraryItemName"];
            GDataXMLElement *matrixEl = [symbolEl walkTo:@"matrix/Matrix"];
            keyframe->matrix = [[SPMatrix alloc]
                initWithA:[matrixEl floatAttribute:@"a" defaultVal:1]
                        b:[matrixEl floatAttribute:@"b" defaultVal:0]
                        c:[matrixEl floatAttribute:@"c" defaultVal:0]
                        d:[matrixEl floatAttribute:@"d" defaultVal:1]
                       tx:[matrixEl floatAttribute:@"tx" defaultVal:0]
                       ty:[matrixEl floatAttribute:@"ty" defaultVal:0]];
            [layer->keyframes addObject:keyframe];
        }
        [movie->layers addObject:layer];
    }
    return movie;
}

@end
