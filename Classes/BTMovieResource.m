//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMovieResource.h"
#import "BTMovieResourceLayer.h"
#import "BTMovieResourceKeyframe.h"
#import "BTResourceFactory.h"
#import "BTMovie.h"
#import "BTMovie+Package.h"
#import "GDataXMLNode+Extensions.h"
#import "BTApp.h"
#import "BTResourceManager.h"
#import "NSArray+Extensions.h"

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
    int numFrames = 0;
    
    NSArray* layerEls = [xml elementsForName:@"layer"];
    
    if ([[layerEls objectAtIndex:0] boolAttribute:@"flipbook" defaultVal:NO]) {
        BTMovieResourceLayer* layer = 
            [[BTMovieResourceLayer alloc] initFlipbookNamed:[xml stringAttribute:@"name"] 
                                                    withXml:[layerEls objectAtIndex:0]];
        [layers addObject:layer];
        numFrames = layer.numFrames;
    } else {
        for (GDataXMLElement* layerEl in layerEls) {
            BTMovieResourceLayer* layer = [[BTMovieResourceLayer alloc] initWithLayer:layerEl];
            [layers addObject:layer];
            numFrames = MAX(numFrames, layer.numFrames);
        }
    }
    
    labels = [[NSMutableArray alloc] initWithCapacity:numFrames];
    for (int ii = 0; ii < numFrames; ii++) {
        [labels insertObject:[[NSMutableArray alloc] init] atIndex:ii];
        if (ii == 0 || ii == numFrames - 1) {
            NSString* label = ii == 0 ? BTMovieFirstFrame : BTMovieLastFrame;
            [[labels lastObject] addObject:label];
        }
    }
    for (BTMovieResourceLayer* layer in layers) {
        for (BTMovieResourceKeyframe* kf in layer->keyframes) {
            if (kf->label) [[labels objectAtIndex:kf->index] addObject:kf->label];
        }
    }
    return self;
}

- (BTMovie*)newMovie {
    return [[BTMovie alloc] initWithLayers:layers andLabels:labels];
}

- (SPDisplayObject*)createDisplayObject { return [self newMovie]; }

+ (id<BTResourceFactory>)sharedFactory {
    static BTMovieResourceFactory* instance;
    @synchronized(self) {
        if (instance == nil) instance = [[BTMovieResourceFactory alloc] init];
    }
    return instance;
}

+ (BTMovie*)newMovie:(NSString *)name {
    return [[BTApp.app.resourceManager requireResource:name 
                                                ofType:[BTMovieResource class]] newMovie];
}

@end


@implementation BTMovieResourceFactory

- (BTResource*)create:(GDataXMLElement*)xml {
    return [[BTMovieResource alloc] initFromXml:xml];
}

@end
