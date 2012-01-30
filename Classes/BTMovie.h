//
// Betwixt - Copyright 2012 Three Rings Design

#import <Foundation/Foundation.h>

#import "BTSprite.h"
#import "BTUpdatable.h"

@class RAIntValue;

@interface BTMovie : BTSprite <BTUpdatable>
@property(nonatomic,readonly) int frames;
@property(nonatomic,readonly,strong) RAIntValue *frame;
@end
