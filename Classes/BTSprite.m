//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTSprite.h"

@implementation BTSprite
- (id)init {
    if (!(self = [super init])) return nil;
    _sprite = [[SPSprite alloc] init];
    return self;
}

- (SPDisplayObject *)display {
    return _sprite;
}

@synthesize sprite=_sprite;

@end
