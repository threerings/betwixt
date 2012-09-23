//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMovieLayer.h"
#import "BTMovie.h"
#import "BTMovieResourceLayer.h"
#import "BTMovieResourceKeyframe.h"
#import "BTApp.h"
#import "BTDisplayObjectCreator.h"
#import "BTResourceManager.h"

@implementation BTMovieLayer

- (BTMovieResourceKeyframe*)kfAtIdx:(int)idx {
    return (BTMovieResourceKeyframe*)keyframes[idx];
}

- (id)initWithMovie:(BTMovie*)parent layer:(BTMovieResourceLayer*)layer {
    if ((self = [super init])) {
        keyframes = layer->keyframes;
        movie = parent;

        SPSprite* emptySprite = [[SPSprite alloc] init];

        // Create the DisplayObjects that are attached to each keyframe
        displays = [[NSMutableArray alloc] initWithCapacity:[keyframes count]];
        for (int ii = 0; ii < [keyframes count]; ++ii) {
            [displays addObject:emptySprite];
        }
        [layer->keyframesForSymbol enumerateKeysAndObjectsUsingBlock:^(id symbol, NSArray* frameIndices, BOOL *stop) {
            NSString* symbolName = OOONSNullToNil(symbol);
            SPDisplayObject* display = nil;
            if (symbolName == nil) {
                display = emptySprite;
            } else {
                id<BTDisplayObjectCreator> res =
                [BTApp.resourceManager requireResource:symbol
                                          conformingTo:@protocol(BTDisplayObjectCreator)];
                display = [res createDisplayObject];
            }

            for (NSNumber* num in frameIndices) {
                displays[num.integerValue] = display;
            }
        }];

        // Add the first keyframe's DisplayObject to the movie
        [movie addChild:displays[0]];

        layerIdx = movie.numChildren - 1;
        [movie childAtIndex:layerIdx].name = layer->name;
    }

    return self;
}

- (void)drawFrame:(int)frame {
    while (keyframeIdx < [keyframes count] - 1 && [self kfAtIdx:keyframeIdx + 1]->index <= frame) {
        keyframeIdx++;
        changedKeyframe = true;
    }
    if (changedKeyframe) {
        SPDisplayObject* display = displays[keyframeIdx];
        if (display != [movie childAtIndex:layerIdx]) {
            [movie removeChildAtIndex:layerIdx];
            [movie addChild:display atIndex:layerIdx];
        }
    }
    changedKeyframe = false;

    BTMovieResourceKeyframe* kf = [self kfAtIdx:keyframeIdx];
    SPDisplayObject* layer = [movie childAtIndex:layerIdx];
    if (keyframeIdx == [keyframes count] - 1|| kf->index == frame) {
        layer.x = kf->x;
        layer.y = kf->y;
        layer.scaleX = kf->scaleX;
        layer.scaleY = kf->scaleY;
        layer.skewX = kf->skewX;
        layer.skewY = kf->skewY;
        layer.alpha = kf->alpha;
    } else {
        float interped = (frame - kf->index)/(float)kf->duration;
        float ease = kf->ease;
        if (ease != 0) {
            float t = 0;
            if (ease < 0) {
                // Ease in
                float inv = 1 - interped;
                t = 1 - inv*inv;
                ease = -ease;
            } else {
                // Ease out
                t = interped * interped;
            }
            interped = ease * t + (1 - ease) * interped;
        }

        BTMovieResourceKeyframe* nextKf = [self kfAtIdx:keyframeIdx + 1];
        layer.x = kf->x + (nextKf->x - kf->x) * interped;
        layer.y = kf->y + (nextKf->y - kf->y) * interped;
        layer.scaleX = kf->scaleX + (nextKf->scaleX - kf->scaleX) * interped;
        layer.scaleY = kf->scaleY + (nextKf->scaleY - kf->scaleY) * interped;
        layer.skewX = kf->skewX + (nextKf->skewX - kf->skewX) * interped;
        layer.skewY = kf->skewY + (nextKf->skewY - kf->skewY) * interped;
        layer.alpha = kf->alpha + (nextKf->alpha - kf->alpha) * interped;
    }

    layer.pivotX = kf->pivotX;
    layer.pivotY = kf->pivotY;
    layer.visible = kf->visible;
}
@end
