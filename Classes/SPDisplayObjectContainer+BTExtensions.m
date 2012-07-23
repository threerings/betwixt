//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPDisplayObjectContainer+BTExtensions.h"

@implementation SPDisplayObjectContainer (BTExtensions)

- (SPSprite*)spriteAtIndex:(int)index {
    SPDisplayObject* child = [self childAtIndex:index];
    return ([child isKindOfClass:[SPSprite class]] ? (SPSprite*)child : nil);
}

- (SPSprite*)spriteByName:(NSString*)name {
    SPDisplayObject* child = [self childByName:name];
    return ([child isKindOfClass:[SPSprite class]] ? (SPSprite*)child : nil);
}

- (SPSprite*)spriteByFormatName:(NSString*)format, ... {
    return [self spriteByName:OOO_FORMAT_TO_STRING(format)];
}

- (SPDisplayObject*)childByFormatName:(NSString*)format, ... {
    return [self childByName:OOO_FORMAT_TO_STRING(format)];
}

@end
