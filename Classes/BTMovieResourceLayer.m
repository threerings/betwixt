//
// Betwixt - Copyright 2011 Three Rings Design

#import "BTMovieResourceLayer.h"
#import "BTMovieResourceKeyframe.h"
#import "GDataXMLNode+OOO.h"

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
