//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObject.h"
#import "BTDisplayNodeContainer.h"

@interface BTSprite : BTDisplayObject<BTDisplayNodeContainer> {
@protected
    SPSprite *_sprite;
}

// These are all the same
@property(nonatomic,readonly) SPSprite *sprite;
@property(nonatomic,readonly) SPDisplayObjectContainer *container;
@property(nonatomic,readonly) SPDisplayObject *display;

- (void)addAndDisplayNode:(BTDisplayObject *)node;
- (void)addAndDisplayNode:(BTDisplayObject *)node onParent:(SPDisplayObjectContainer *)parent;

@end
