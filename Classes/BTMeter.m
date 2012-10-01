//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMeter.h"

@implementation BTMeterBase

@synthesize maxValue = _maxValue;
@synthesize minValue = _minValue;
@synthesize value = _value;

- (id)initWithSprite:(SPSprite*)sprite {
    if ((self = [super initWithSprite:sprite])) {
        _needsDisplayUpdate = YES;
    }
    return self;
}

- (id)init {
    if ((self = [super init])) {
        _needsDisplayUpdate = YES;
    }
    return self;
}

- (SPSprite*)sprite {
    // update our display whenever the sprite is requested
    if (_needsDisplayUpdate) {
        _needsDisplayUpdate = NO;
        [self updateDisplay];
    }
    return [super sprite];
}

- (float)normalizedValue {
    float denom = (_maxValue - _minValue);
    return (denom != 0 ? (_value - _minValue) / denom : 0);
}

- (void)update:(float)dt {
    if (_needsDisplayUpdate) {
        _needsDisplayUpdate = NO;
        [self updateDisplay];
    }
}

- (void)updateDisplay {

}

- (void)setMaxValue:(float)maxValue {
    if (_maxValue != maxValue) {
        _maxValue = maxValue;
        _minValue = MIN(_minValue, _maxValue);
        _value = MIN(_value, _maxValue);
        _value = MAX(_value, _minValue);
        _needsDisplayUpdate = YES;
    }
}

- (void)setMinValue:(float)minValue {
    if (_minValue != minValue) {
        _minValue = minValue;
        _maxValue = MAX(_maxValue, _minValue);
        _value = MIN(_value, _maxValue);
        _value = MAX(_value, _minValue);
        _needsDisplayUpdate = YES;
    }
}

- (void)setValue:(float)value {
    value = MIN(value, _maxValue);
    value = MAX(value, _minValue);

    if (_value != value) {
        _value = value;
        _needsDisplayUpdate = YES;
    }
}

@end