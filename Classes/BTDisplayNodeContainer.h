//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTNodeContainer.h"

@class BTDisplayObject;

@protocol BTDisplayNodeContainer <BTNodeContainer>

- (void)addAndDisplayNode:(BTDisplayObject *)node;
- (void)addAndDisplayNode:(BTDisplayObject *)node onParent:(SPDisplayObjectContainer *)parent;

@end