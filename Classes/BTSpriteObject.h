//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTViewObject.h"

@interface BTSpriteObject : BTViewObject {
@protected
    SPSprite* _sprite;
}

+ (BTSpriteObject*)sprite;
+ (BTSpriteObject*)withSprite:(SPSprite*)sprite;

- (id)init;
- (id)initWithSprite:(SPSprite*)sprite;

@property(nonatomic,readonly) SPSprite* sprite;

@end
