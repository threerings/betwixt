//
// Betwixt - Copyright 2011 Three Rings Design

#import "BTSprite.h"

@implementation BTSprite
- (id)init {
    if (!(self = [super init])) return nil;
    _sprite = [[SPSprite alloc] init];
    [self.detached connectUnit:^ { [_sprite removeFromParent]; }];
    return self;
}

- (SPDisplayObject*)display {
    return _sprite;
}

@synthesize sprite=_sprite;

@end
