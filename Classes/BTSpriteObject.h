//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTViewObject.h"

@interface BTSpriteObject : BTViewObject {
@protected
    SPSprite* _sprite;
}

@property (nonatomic,readonly) SPSprite* sprite;

+ (BTSpriteObject*)spriteObject;
+ (BTSpriteObject*)spriteObjectWithSprite:(SPSprite*)sprite;

- (id)init;
- (id)initWithSprite:(SPSprite*)sprite;

@end
