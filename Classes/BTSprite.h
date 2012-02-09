//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObject.h"

@interface BTSprite : BTDisplayObject {
@protected
    SPSprite* _sprite;
}

@property(nonatomic,readonly) SPSprite* sprite;

@end
