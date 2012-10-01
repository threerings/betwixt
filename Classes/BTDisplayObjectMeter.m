//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayObjectMeter.h"

@implementation BTDisplayObjectMeter

@synthesize fillDirection = _fillDirection;

- (id)initWithDisplayObject:(SPDisplayObject*)disp {
    if ((self = [super init])) {
        if ([disp isKindOfClass:[SPSprite class]]) {
            _view = (SPSprite*)disp;
        } else {
            _view = [SPSprite sprite];
            [_view addChild:disp];
        }

        _bounds = _view.bounds;
        [_sprite addChild:_view];

        _fillDirection = BTMeterFill_LeftRight;
    }
    return self;
}

- (void)updateDisplay {
    float normalizedVal = self.normalizedValue;
    if (normalizedVal == 0) {
        _view.visible = NO;
        return;
    }

    // clip our view
    SPRectangle* clipRect = nil;
    if (normalizedVal < 1) {
        float x, y, width, height;
        switch (_fillDirection) {
            case BTMeterFill_LeftRight:
                width = _bounds.width * normalizedVal;
                height = _bounds.height;
                x = _bounds.x;
                y = _bounds.y;
                break;

            case BTMeterFill_RightLeft:
                width = _bounds.width * normalizedVal;
                height = _bounds.height;
                x = _bounds.x + _bounds.width - width;
                y = _bounds.y;
                break;

            case BTMeterFill_TopBottom:
                width = _bounds.width;
                height = _bounds.height * normalizedVal;
                x = _bounds.x;
                y = _bounds.y;
                break;

            case BTMeterFill_BottomTop:
                width = _bounds.width;
                height = _bounds.height * normalizedVal;
                x = _bounds.x;
                y = _bounds.y + _bounds.height - height;
                break;
        }

        clipRect = [[SPRectangle alloc] initWithX:x y:y width:width height:height];
    }

    _view.visible = YES;
    _view.clipRect = clipRect;
}

- (void)setFillDirection:(BTMeterFillDirection)fillDirection {
    if (_fillDirection != fillDirection) {
        _fillDirection = fillDirection;
        _needsDisplayUpdate = YES;
    }
}

@end
