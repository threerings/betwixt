//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObjectContainer.h"
#import "BTObject.h"

@interface BTSprite : BTDisplayObjectContainer {
@protected
    SPSprite *_sprite;
}

@property(readonly,nonatomic) SPSprite *sprite;
@end
