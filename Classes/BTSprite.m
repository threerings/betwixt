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

- (SPDisplayObject*)display {
    return _sprite;
}

- (void)displayNode:(BTNode<BTDisplayable>*)node {
    [self addNode:node];
    [_sprite addChild:node.display];
}

@synthesize sprite=_sprite;

@end
