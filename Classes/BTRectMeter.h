//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMeter.h"

/// A rectangular meter
@interface BTRectMeter : BTMeterBase {
@protected
    float _width;
    float _height;
    float _outlineSize;
    BTMeterFillDirection _fillDirection;

    uint32_t _outlineColor;
    uint32_t _backgroundColor;
    uint32_t _foregroundColorFull;
    uint32_t _foregroundColorEmpty;
}

@property (nonatomic,readonly) float width;
@property (nonatomic,readonly) float height;
@property (nonatomic,assign) float outlineSize;
@property (nonatomic,assign) BTMeterFillDirection fillDirection;

@property (nonatomic,assign) uint32_t outlineColor;
@property (nonatomic,assign) uint32_t backgroundColor;
@property (nonatomic,assign) uint32_t foregroundColor;
@property (nonatomic,assign) uint32_t foregroundColorFull;
@property (nonatomic,assign) uint32_t foregroundColorEmpty;

- (id)initWithWidth:(int)width height:(int)height;

@end
