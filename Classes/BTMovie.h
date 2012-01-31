//
// Betwixt - Copyright 2012 Three Rings Design

#import <Foundation/Foundation.h>

#import "BTSprite.h"
#import "BTUpdatable.h"

@class RABoolValue;

@interface BTMovie : BTSprite <BTUpdatable>

@property(nonatomic,readonly) RABoolValue *playing;
@property(nonatomic,readonly) float duration;
@end
