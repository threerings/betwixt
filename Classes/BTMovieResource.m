//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMovieResource.h"
#import "BTMovieResourceLayer.h"
#import "BTMovieResourceKeyframe.h"
#import "BTResourceFactory.h"
#import "BTMovie.h"
#import "BTMovie+Package.h"
#import "GDataXMLNode+Extensions.h"

@interface BTMovieResourceFactory : NSObject<BTResourceFactory>
@end

@implementation BTMovieResource {
@public
    NSMutableArray* layers;
    NSMutableArray* labels;
}

- (id)initFromXml:(GDataXMLElement*)xml {
    if (!(self = [super init])) return nil;
    layers = [[NSMutableArray alloc] init];
    GDataXMLElement* layersEl = [xml walkTo:@"DOMSymbolItem/timeline/DOMTimeline/layers"];
    int frames = 0;
    for (GDataXMLElement* layerEl in [layersEl elements]) {
        BTMovieResourceLayer* layer = [[BTMovieResourceLayer alloc] initWithLayer:layerEl];
        [layers addObject:layer];
        BTMovieResourceKeyframe* lastKf = [layer->keyframes lastObject];
        int layerFrames = lastKf->index + lastKf->duration;
        if (layerFrames > frames) frames = layerFrames;
    }
    labels = [[NSMutableArray alloc] initWithCapacity:frames];
    for (int ii = 0; ii < frames; ii++) {
        [labels insertObject:[[NSMutableArray alloc] init] atIndex:ii];
        if (ii == 0 || ii == frames - 1) {
            NSString* label = ii == 0 ? BTMovieFirstFrame : BTMovieLastFrame;
            [[labels lastObject] addObject:label];
        }
    }
    return self;
}

- (BTMovie*)newMovie {
    return [[BTMovie alloc] initWithLayers:layers andLabels:labels];
}

+ (id<BTResourceFactory>)sharedFactory {
    static BTMovieResourceFactory* instance;
    @synchronized(self) {
        if (instance == nil) instance = [[BTMovieResourceFactory alloc] init];
    }
    return instance;
}

@end


@implementation BTMovieResourceFactory

- (BTResource*)create:(GDataXMLElement*)xml {
    return [[BTMovieResource alloc] initFromXml:xml];
}

@end
