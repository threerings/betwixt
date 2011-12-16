//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "SPSprite.h"
#import "BTGeneration.h"

@interface BTMode : BTGeneration {
@private
    SPSprite *_sprite;
}

@property(readonly,nonatomic) SPSprite *sprite;

@end
