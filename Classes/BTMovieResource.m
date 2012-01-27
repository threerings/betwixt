//
//  Betwixt - Copyright 2012 Three Rings Design

#import "BTMovieResource.h"
#import "BTMovieResourceLayer.h"
#import "BTResourceFactory.h"
#import "BTMovie.h"
#import "BTMovie+Package.h"
#import "GDataXMLNode+OOO.h"

@interface BTMovieResourceFactory : NSObject<BTResourceFactory>
@end

@implementation BTMovieResource {
@public
    NSMutableArray *layers;
}

- (id)initFromXml:(GDataXMLElement*)xml {
    if (!(self = [super init])) return nil;
    layers = [[NSMutableArray alloc] init];
    GDataXMLElement *layersEl = [xml walkTo:@"DOMSymbolItem/timeline/DOMTimeline/layers"];
    for (GDataXMLElement *layerEl in [layersEl elements]) {
        [layers addObject:[[BTMovieResourceLayer alloc] initWithLayer:layerEl]];
    }
    return self;
}

- (BTMovie*)newMovie {
    return [[BTMovie alloc] initWithLayers:layers];
}

+ (id<BTResourceFactory>)sharedFactory {
    static BTMovieResourceFactory *instance;
    @synchronized(self) {
        if (instance == nil) instance = [[BTMovieResourceFactory alloc] init];
    }
    return instance;
}

@end


@implementation BTMovieResourceFactory

- (BTResource *)create:(GDataXMLElement *)xml {
    return [[BTMovieResource alloc] initFromXml:xml];
}

@end
