//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMovieResource.h"
#import "BTMovieResourceLayer.h"
#import "BTMovieResourceKeyframe.h"
#import "BTResourceFactory.h"
#import "BTMovie.h"
#import "BTMovie+Package.h"
#import "GDataXMLNode+BTExtensions.h"
#import "BTApp.h"
#import "BTResourceManager.h"
#import "BTDeviceType.h"

static NSString* const LOOP_START_PREFIX = @"loop_start";
static NSString* const LOOP_END_PREFIX = @"loop_end";

static NSString* LabelToLoopStartName (NSString* label) {
    return ([label startsWith:LOOP_START_PREFIX] ?
            [label substringFromIndex:LOOP_START_PREFIX.length] :
            nil);
}

static NSString* LabelToLoopEndName (NSString* label) {
    return ([label startsWith:LOOP_END_PREFIX] ?
            [label substringFromIndex:LOOP_END_PREFIX.length] :
            nil);
}

static NSString* LoopStartNameToLabel (NSString* name) {
    return [NSString stringWithFormat:@"%@%@", LOOP_START_PREFIX, name];
}

static NSString* LoopEndNameToLabel (NSString* name) {
    return [NSString stringWithFormat:@"%@%@", LOOP_END_PREFIX, name];
}

@interface BTMovieResourceFactory : NSObject<BTResourceFactory>
@end

@implementation BTMovieResource

- (id)initFromXml:(GDataXMLElement*)xml {
    if ((self = [super init])) {
        _layers = [[NSMutableArray alloc] init];
        int numFrames = 0;

        _framerate = [xml floatAttribute:@"frameRate" defaultVal:30];

        NSArray* layerEls = [xml elementsForName:@"layer"];

        if ([layerEls[0] boolAttribute:@"flipbook" defaultVal:NO]) {
            BTMovieResourceLayer* layer =
            [[BTMovieResourceLayer alloc] initFlipbookNamed:[xml stringAttribute:@"name"]
                                                        xml:layerEls[0]];
            [_layers addObject:layer];
            numFrames = layer.numFrames;
        } else {
            for (GDataXMLElement* layerEl in layerEls) {
                BTMovieResourceLayer* layer = [[BTMovieResourceLayer alloc] initWithXml:layerEl];
                [_layers addObject:layer];
                numFrames = MAX(numFrames, layer.numFrames);
            }
        }

        _labels = [[NSMutableArray alloc] initWithCapacity:numFrames];
        for (int ii = 0; ii < numFrames; ii++) {
            [_labels insertObject:[[NSMutableArray alloc] init] atIndex:ii];
            if (ii == 0 || ii == numFrames - 1) {
                NSString* label = ii == 0 ? BTMovieFirstFrame : BTMovieLastFrame;
                [[_labels lastObject] addObject:label];
            }
        }

        NSMutableSet* allLoopStarts = [[NSMutableSet alloc] init];
        NSMutableSet* unmatchedLoopStarts = [[NSMutableSet alloc] init];
        _loopLabels = [[NSMutableArray alloc] init];
        for (BTMovieResourceLayer* layer in _layers) {
            for (BTMovieResourceKeyframe* kf in layer->keyframes) {
                NSString* label = kf->label;
                if (label != nil) {
                    [_labels[kf->index] addObject:label];

                    // is this label part of a loop?
                    NSString* loopName = LabelToLoopStartName(label);
                    if (loopName != nil) {
                        if ([allLoopStarts containsObject:loopName]) {
                            NSLog(@"Duplicate loop start '%@'", LoopStartNameToLabel(loopName));
                        } else {
                            [allLoopStarts addObject:loopName];
                            [unmatchedLoopStarts addObject:loopName];
                        }

                    } else {
                        loopName = LabelToLoopEndName(label);
                        if (loopName != nil) {
                            if (!([unmatchedLoopStarts containsObject:loopName])) {
                                NSLog(@"Unmatched loop end '%@'", LoopEndNameToLabel(loopName));
                            } else {
                                [unmatchedLoopStarts removeObject:loopName];
                                [_loopLabels addObject:LoopStartNameToLabel(loopName)];
                                [_loopLabels addObject:LoopEndNameToLabel(loopName)];
                            }
                        }
                    }
                }
            }
        }

        for (NSString* unmatchedLoopStart in unmatchedLoopStarts) {
            NSLog(@"Unmatched loop start '%@'", LoopStartNameToLabel(unmatchedLoopStart));
        }

    }
    return self;
}

- (BTMovie*)newMovie {
    BTMovie* movie = [[BTMovie alloc] initWithFramerate:_framerate layers:_layers labels:_labels];
    for (int ii = 0; ii < _loopLabels.count; ii += 2) {
        [movie addLoopWithStart:_loopLabels[ii] end:_loopLabels[ii + 1]];
    }
    return movie;
}

- (SPDisplayObject*)createDisplayObject { return [self newMovie]; }

+ (id<BTResourceFactory>)sharedFactory {
    return OOO_SINGLETON([[BTMovieResourceFactory alloc] init]);
}

+ (BTMovieResource*)require:(NSString*)name {
    return [BTApp.resourceManager requireResource:name ofType:[BTMovieResource class]];
}

+ (BTMovie*)newMovie:(NSString*)name {
    return [[BTMovieResource require:name] newMovie];
}

@end


@implementation BTMovieResourceFactory

- (BTResource*)create:(GDataXMLElement*)xml {
    return [[BTMovieResource alloc] initFromXml:xml];
}

@end
