//
// Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTDisplayable.h"
#import "BTDisplayContext.h"
#import "BTObject.h"

@interface BTSprite : BTObject <BTDisplayable,BTDisplayContext> {
@protected
    SPSprite *_sprite;
}

@property(readonly,nonatomic) SPSprite *sprite;
@end
