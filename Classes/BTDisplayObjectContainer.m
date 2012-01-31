//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObjectContainer.h"

@implementation BTDisplayObjectContainer

- (SPDisplayObjectContainer *)container {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (SPDisplayObject *)display {
    return self.container;
}

- (void)addAndDisplayNode:(BTNode<BTDisplayable> *)node {
    [self addNode:node];
    [self.container addChild:node.display];
}

@end