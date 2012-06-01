//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTSpriteObject.h"

@implementation BTSpriteObject

@synthesize sprite = _sprite;

+ (BTSpriteObject*)sprite {
    return [[BTSpriteObject alloc] init];
}

+ (BTSpriteObject*)withSprite:(SPSprite *)sprite {
    return [[BTSpriteObject alloc] initWithSprite:sprite];
}

- (id)init {
    return [self initWithSprite:[SPSprite sprite]];
}

- (id)initWithSprite:(SPSprite*)sprite {
    if ((self = [super init])) {
        _sprite = sprite;
    }
    return self;
}

- (SPDisplayObject*)display {
    return self.sprite;
}

@end
