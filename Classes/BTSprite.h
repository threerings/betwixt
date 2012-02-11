//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObject.h"

@interface BTSprite : BTDisplayObject {
@protected
    SPSprite* _sprite;
}

+ (BTSprite*)sprite;
+ (BTSprite*)withSprite:(SPSprite*)sprite;

- (id)init;
- (id)initWithSprite:(SPSprite*)sprite;

@property(nonatomic,readonly) SPSprite* sprite;

@end
