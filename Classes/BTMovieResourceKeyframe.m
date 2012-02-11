//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMovieResourceKeyframe.h"
#import "GDataXMLNode+Extensions.h"

@implementation BTMovieResourceKeyframe
-initWithFrame:(GDataXMLElement*)frameEl {
    if (!(self = [super init])) return nil;
    index = [frameEl intAttribute:@"index"];
    duration = [frameEl intAttribute:@"duration" defaultVal:1];

    GDataXMLElement* symbolEl = [frameEl walkTo:@"elements/DOMSymbolInstance"];
    libraryItem = [symbolEl stringAttribute:@"libraryItemName"];

    GDataXMLElement* matrixEl = [symbolEl walkTo:@"matrix/Matrix"];
    SPMatrix* mat = [[SPMatrix alloc] initWithA:[matrixEl floatAttribute:@"a" defaultVal:1]
                                                 b:[matrixEl floatAttribute:@"b" defaultVal:0]
                                                 c:[matrixEl floatAttribute:@"c" defaultVal:0]
                                                 d:[matrixEl floatAttribute:@"d" defaultVal:1]
                                                tx:[matrixEl floatAttribute:@"tx" defaultVal:0]
                                                ty:[matrixEl floatAttribute:@"ty" defaultVal:0]];
    x = mat.tx;
    y = mat.ty;
    SPPoint* py = [mat transformPoint:[SPPoint pointWithX:1 y:0]];
    py.x -= mat.tx;
    py.y -= mat.ty;
    rotation = atan2(py.y, py.x);
    scaleX = sqrt(mat.a * mat.a + mat.b * mat.b);
    scaleY = sqrt(mat.c * mat.c + mat.d * mat.d);
    return self;
}
@end
