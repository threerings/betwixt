//
// Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>

#import "BTSprite.h"
#import "BTUpdatable.h"

@interface BTMovie : BTSprite <BTUpdatable>
@property(nonatomic,readwrite) int frame;
@end
