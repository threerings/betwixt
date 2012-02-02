//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTNodeContainer.h"

@protocol BTDisplayable;

@protocol BTDisplayNodeContainer <BTNodeContainer>

@property(nonatomic,readonly) SPDisplayObjectContainer *container;

- (void)addAndDisplayNode:(BTNode<BTDisplayable> *)node;

@end