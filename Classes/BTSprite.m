//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTSprite.h"

@implementation BTSprite

+ (BTSprite*)sprite {
    return [[BTSprite alloc] init];
}

+ (BTSprite*)withSprite:(SPSprite *)sprite {
    return [[BTSprite alloc] initWithSprite:sprite];
}

- (id)init {
    if (!(self = [super init])) return nil;
    _sprite = [[SPSprite alloc] init];
    return self;
}

- (id)initWithSprite:(SPSprite*)sprite {
    if (!(self = [super init])) return nil;
    _sprite = sprite;
    return self;
}

- (SPDisplayObject*)display {
    return _sprite;
}

@synthesize sprite=_sprite;

@end
