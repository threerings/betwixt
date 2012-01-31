//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTNodeContainer.h"
#import "BTDisplayable.h"

@interface BTDisplayObjectContainer : BTNodeContainer<BTDisplayable>

@property(nonatomic,readonly) SPDisplayObjectContainer *container;

- (void)addAndDisplayNode:(BTNode<BTDisplayable> *)node;

@end
