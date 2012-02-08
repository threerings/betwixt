//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTSprite.h"

@implementation BTSprite
- (id)init {
    if (!(self = [super init])) return nil;
    _sprite = [[SPSprite alloc] init];
    return self;
}

- (void)addAndDisplayNode:(BTDisplayObject *)node {
    [self addAndDisplayNode:node onParent:self.container];
}

- (void)addAndDisplayNode:(BTDisplayObject *)node onParent:(SPDisplayObjectContainer *)parent {
    [self addNode:node];
    [parent addChild:node.display];
}

- (SPDisplayObjectContainer *)container {
    return _sprite;
}

- (SPDisplayObject *)display {
    return _sprite;
}

@synthesize sprite=_sprite;

@end
