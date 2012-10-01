//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTSpriteObject.h"
#import "BTUpdatable.h"

typedef enum {
    BTMeterFill_LeftRight = 0,
    BTMeterFill_RightLeft,
    BTMeterFill_TopBottom,
    BTMeterFill_BottomTop
} BTMeterFillDirection;

@protocol BTMeter

@property (nonatomic,assign) float maxValue;
@property (nonatomic,assign) float minValue;
@property (nonatomic,assign) float value;

@end

@interface BTMeterBase : BTSpriteObject <BTUpdatable,BTMeter> {
@protected
    float _maxValue;
    float _minValue;
    float _value;

    BOOL _needsDisplayUpdate;
}

@property (nonatomic,assign) float maxValue;
@property (nonatomic,assign) float minValue;
@property (nonatomic,assign) float value;
@property (nonatomic,readonly) float normalizedValue;

- (id)initWithSprite:(SPSprite*)sprite;
- (id)init;

// protected
- (void)updateDisplay;

@end
