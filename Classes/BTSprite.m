//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTSprite.h"

@implementation BTSprite
- (id)init {
    if (!(self = [super init])) return nil;
    _sprite = [[SPSprite alloc] init];
    [self.detached connectUnit:^ { [_sprite removeFromParent]; }];
    return self;
}

- (void)addAndDisplayNode:(BTDisplayObject *)node {
    [self addNode:node];
    [_sprite addChild:node.display];
}

- (SPDisplayObjectContainer *)container {
    return _sprite;
}

- (SPDisplayObject *)display {
    return _sprite;
}

@synthesize sprite=_sprite;

@end
