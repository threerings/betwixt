//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMovieResourceLayer.h"
#import "BTMovieResourceKeyframe.h"
#import "GDataXMLNode+Extensions.h"

@implementation BTMovieResourceLayer
-initWithLayer:(GDataXMLElement*)layerEl {
    if (!(self = [super init])) return nil;
    keyframes = [[NSMutableArray alloc] init];
    name = [layerEl stringAttribute:@"name"];
    for (GDataXMLElement* frameEl in [[layerEl requireChild:@"frames"] elements]) {
        [keyframes addObject:[[BTMovieResourceKeyframe alloc] initWithFrame:frameEl]];
    }
    return self;
}

-(id)initFlipbookNamed:(NSString*)animName withXml:(GDataXMLElement *)layerEl {
    if (!(self = [super init])) return nil;
    keyframes = [[NSMutableArray alloc] init];
    name = [layerEl stringAttribute:@"name"];
    for (GDataXMLElement* frameEl in [[layerEl requireChild:@"frames"] elements]) {
        [keyframes addObject:[[BTMovieResourceKeyframe alloc] initFlipbookNamed:animName withXml:frameEl]];
    }
    return self;
}

-(int)frames {
    BTMovieResourceKeyframe* lastKf = [keyframes lastObject];
    return lastKf->index + lastKf->duration;
}
@end
