//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMovieResourceKeyframe.h"
#import "GDataXMLNode+Extensions.h"
#import "SPMatrix+Extensions.h"

@implementation BTMovieResourceKeyframe
-initWithFrame:(GDataXMLElement*)frameEl {
    if (!(self = [super init])) return nil;
    index = [frameEl intAttribute:@"index"];
    duration = [frameEl intAttribute:@"duration" defaultVal:1];
    label = [frameEl stringAttribute:@"name" defaultVal:nil];

    GDataXMLElement* symbolEl = [frameEl getChild:@"elements/DOMSymbolInstance"];
    libraryItem = [symbolEl stringAttribute:@"libraryItemName"];

    GDataXMLElement* matrixEl = [symbolEl getChild:@"matrix/Matrix"];
    SPMatrix* mat;
    if (matrixEl) {
        mat = [[SPMatrix alloc] initWithA:[matrixEl floatAttribute:@"a" defaultVal:1]
                                                 b:[matrixEl floatAttribute:@"b" defaultVal:0]
                                                 c:[matrixEl floatAttribute:@"c" defaultVal:0]
                                                 d:[matrixEl floatAttribute:@"d" defaultVal:1]
                                                tx:[matrixEl floatAttribute:@"tx" defaultVal:0]
                                                ty:[matrixEl floatAttribute:@"ty" defaultVal:0]];
    } else mat = [[SPMatrix alloc] init];
    
    x = mat.tx;
    y = mat.ty;
    rotation = mat.rotation;
    scaleX = mat.scaleX;
    scaleY = mat.scaleY;
    return self;
}


-initFlipbookNamed:(NSString*)name withXml:(GDataXMLElement*)frameEl {
    if (!(self = [super init])) return nil;
    index = [frameEl intAttribute:@"index"];
    duration = [frameEl intAttribute:@"duration" defaultVal:1];
    label = [frameEl stringAttribute:@"name" defaultVal:nil];

    libraryItem = [NSString stringWithFormat:@"%@_flipbook_%d", name, index];

    scaleX = 1;
    scaleY = 1;
    return self;

}
@end
