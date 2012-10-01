//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMeter.h"

@interface BTDisplayObjectMeter : BTMeterBase {
@protected
    SPSprite* _view;
    SPRectangle* _bounds;

    BTMeterFillDirection _fillDirection;
}

@property (nonatomic,assign) BTMeterFillDirection fillDirection;

- (id)initWithDisplayObject:(SPDisplayObject*)disp;

@end