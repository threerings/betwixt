//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTSprite.h"

@implementation BTSprite

@synthesize sprite = _sprite;

+ (BTSprite*)sprite {
    return [[BTSprite alloc] init];
}

+ (BTSprite*)withSprite:(SPSprite *)sprite {
    return [[BTSprite alloc] initWithSprite:sprite];
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
