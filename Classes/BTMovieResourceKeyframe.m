//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMovieResourceKeyframe.h"
#import "GDataXMLNode+BTExtensions.h"
#import "SPMatrix+BTExtensions.h"

@implementation BTMovieResourceKeyframe
- (id)initWithIndex:(int)theIndex xml:(GDataXMLElement*)frameEl {
    if ((self = [super init])) {
        index = theIndex;
        duration = [frameEl intAttribute:@"duration" defaultVal:1];
        label = [frameEl stringAttribute:@"label" defaultVal:nil];
        libraryItem = [frameEl stringAttribute:@"ref" defaultVal:nil];
        
        SPPoint* loc = [frameEl pointAttribute:@"loc" defaultVal:nil];
        if (loc != nil) {
            x = loc.x;
            y = loc.y;
        }
        
        SPPoint* scale = [frameEl pointAttribute:@"scale" defaultVal:nil];
        if (scale != nil) {
            scaleX = scale.x;
            scaleY = scale.y;
        } else {
            scaleX = 1;
            scaleY = 1;
        }
        
        SPPoint* skew = [frameEl pointAttribute:@"skew" defaultVal:nil];
        if (skew != nil) {
            skewX = skew.x;
            skewY = skew.y;
        } else {
            skewX = skewY = [frameEl floatAttribute:@"rotation" defaultVal:0];
        }   
        
        SPPoint* pivot = [frameEl pointAttribute:@"pivot" defaultVal:nil];
        if (pivot != nil) {
            pivotX = pivot.x;
            pivotY = pivot.y;
        }
        
        alpha = [frameEl floatAttribute:@"alpha" defaultVal:1];
        visible = [frameEl boolAttribute:@"visible" defaultVal:YES];
        ease = [frameEl floatAttribute:@"ease" defaultVal:0];
    }
    
    return self;
}


- (id)initFlipbookNamed:(NSString*)name withIndex:(int)theIndex xml:(GDataXMLElement*)frameEl {
    if ((self = [super init])) {
        index = theIndex;
        duration = [frameEl intAttribute:@"duration" defaultVal:1];
        label = [frameEl stringAttribute:@"label" defaultVal:nil];

        libraryItem = [NSString stringWithFormat:@"%@_flipbook_%d", name, index];

        scaleX = 1;
        scaleY = 1;
    }
    return self;

}
@end
