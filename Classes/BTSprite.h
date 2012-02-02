//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTObject.h"
#import "BTDisplayNodeContainer.h"
#import "BTDisplayable.h"

@interface BTSprite : BTObject<BTDisplayNodeContainer,BTDisplayable> {
@protected
    SPSprite *_sprite;
}

// These are all the same
@property(nonatomic,readonly) SPSprite *sprite;
@property(nonatomic,readonly) SPDisplayObjectContainer *container;
@property(nonatomic,readonly) SPDisplayObject *display;

- (void)addAndDisplayNode:(BTNode<BTDisplayable> *)node;

@end
