//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "SPSprite.h"
#import "BTGeneration.h"
#import "BTDisplayable.h"

@interface BTMode : BTGeneration<BTDisplayable> {
@private
    SPSprite *_sprite;
}

@property(readonly,nonatomic) SPSprite *sprite;

@end
