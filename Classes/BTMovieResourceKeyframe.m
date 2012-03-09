//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMovieResourceKeyframe.h"
#import "GDataXMLNode+Extensions.h"
#import "SPMatrix+Extensions.h"

@implementation BTMovieResourceKeyframe
- (id)initWithIndex:(int)theIndex xml:(GDataXMLElement*)frameEl {
    if (!(self = [super init])) return nil;
    
    index = theIndex;
    duration = [frameEl intAttribute:@"duration" defaultVal:1];
    label = [frameEl stringAttribute:@"label" defaultVal:nil];
    libraryItem = [frameEl stringAttribute:@"ref" defaultVal:nil];
    
    x = [frameEl floatAttribute:@"x" defaultVal:0];
    y = [frameEl floatAttribute:@"y" defaultVal:0];
    rotation = [frameEl floatAttribute:@"rotation" defaultVal:0];
    scaleX = [frameEl floatAttribute:@"scaleX" defaultVal:1];
    scaleY = [frameEl floatAttribute:@"scaleY" defaultVal:1];
    pivotX = [frameEl floatAttribute:@"pivotX" defaultVal:0];
    pivotY = [frameEl floatAttribute:@"pivotY" defaultVal:0];
    
    return self;
}


- (id)initFlipbookNamed:(NSString*)name withIndex:(int)theIndex xml:(GDataXMLElement*)frameEl {
    if (!(self = [super init])) return nil;
    index = theIndex;
    duration = [frameEl intAttribute:@"duration" defaultVal:1];
    label = [frameEl stringAttribute:@"label" defaultVal:nil];

    libraryItem = [NSString stringWithFormat:@"%@_flipbook_%d", name, index];

    scaleX = 1;
    scaleY = 1;
    return self;

}
@end
