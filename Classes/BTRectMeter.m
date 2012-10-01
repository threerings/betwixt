//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTRectMeter.h"
#import "BTDisplayUtil.h"

@implementation BTRectMeter

@synthesize width = _width;
@synthesize height = _height;
@synthesize fillDirection = _fillDirection;
@synthesize outlineSize = _outlineSize;
@synthesize outlineColor = _outlineColor;
@synthesize backgroundColor = _backgroundColor;
@synthesize foregroundColorFull = _foregroundColorFull;
@synthesize foregroundColorEmpty = _foregroundColorEmpty;

- (id)initWithWidth:(int)width height:(int)height {
    if ((self = [super init])) {
        _width = width;
        _height = height;
        _outlineSize = 1;
        _fillDirection = BTMeterFill_LeftRight;
    }
    return self;
}

- (uint32_t)foregroundColor {
    return _foregroundColorFull;
}

- (void)updateDisplay {
    float normalizedVal = self.normalizedValue;

    float fgStart = 0;
    float fgSize = 0;
    float bgStart = 0;
    float bgSize = 0;

    switch (_fillDirection) {
        case BTMeterFill_LeftRight:
            fgSize = normalizedVal * _width;
            bgSize = _width - fgSize;
            fgStart = 0;
            bgStart = fgSize;
            break;

        case BTMeterFill_RightLeft:
            fgSize = normalizedVal * _width;
            bgSize = _width - fgSize;
            fgStart = bgSize;
            bgStart = 0;
            break;

        case BTMeterFill_TopBottom:
            fgSize = normalizedVal * _height;
            bgSize = _height - fgSize;
            fgStart = 0;
            bgStart = fgSize;
            break;

        case BTMeterFill_BottomTop:
            fgSize = normalizedVal * _height;
            bgSize = _height - fgSize;
            fgStart = bgSize;
            bgStart = 0;
            break;
    }

    [_sprite removeAllChildren];

    BOOL vertical = (_fillDirection == BTMeterFill_TopBottom || _fillDirection == BTMeterFill_BottomTop);

    // draw foreground
    if (fgSize > 0) {
        float x, y, w, h;
        if (vertical) {
            x = 0;
            y = fgStart;
            w = _width;
            h = fgSize;
        } else {
            x = fgStart;
            y = 0;
            w = fgSize;
            h = _height;
        }

        uint32_t fgColor = BTBlendARGB(_foregroundColorFull, _foregroundColorEmpty, normalizedVal);
        SPDisplayObject* fg = [BTDisplayUtil fillRectWithWidth:w height:h color:fgColor];
        fg.x = x;
        fg.y = y;
        [_sprite addChild:fg];
    }

    // draw background
    if (bgSize > 0) {
        float x, y, w, h;
        if (vertical) {
            x = 0;
            y = bgStart;
            w = _width;
            h = fgSize;
        } else {
            x = bgStart;
            y = 0;
            w = bgSize;
            h = _height;
        }

        SPDisplayObject* bg = [BTDisplayUtil fillRectWithWidth:w height:h color:_backgroundColor];
        bg.x = x;
        bg.y = y;
        [_sprite addChild:bg];
    }

    // draw outline
    if (_outlineSize > 0) {
        [_sprite addChild:[BTDisplayUtil lineRectWithWidth:_width
                                                    height:_height
                                                     color:_outlineColor
                                               outlineSize:_outlineSize]];
    }
}

- (void)setFillDirection:(BTMeterFillDirection)fillDirection {
    if (_fillDirection != fillDirection) {
        _fillDirection = fillDirection;
        _needsDisplayUpdate = YES;
    }
}

- (void)setOutlineSize:(float)outlineSize {
    if (_outlineSize != outlineSize) {
        _outlineSize = outlineSize;
        _needsDisplayUpdate = YES;
    }
}

- (void)setOutlineColor:(uint32_t)outlineColor {
    if (_outlineColor != outlineColor) {
        _outlineColor = outlineColor;
        _needsDisplayUpdate = YES;
    }
}

- (void)setBackgroundColor:(uint32_t)backgroundColor {
    if (_backgroundColor != backgroundColor) {
        _backgroundColor = backgroundColor;
        _needsDisplayUpdate = YES;
    }
}

- (void)setForegroundColorFull:(uint32_t)foregroundColorFull {
    if (_foregroundColorFull != foregroundColorFull) {
        _foregroundColorFull = foregroundColorFull;
        _needsDisplayUpdate = YES;
    }
}

- (void)setForegroundColorEmpty:(uint32_t)setForegroundColorEmpty {
    if (_foregroundColorEmpty != setForegroundColorEmpty) {
        _foregroundColorEmpty = setForegroundColorEmpty;
        _needsDisplayUpdate = YES;
    }
}

- (void)setForegroundColor:(uint)foregroundColor {
    self.foregroundColorEmpty = foregroundColor;
    self.foregroundColorFull = foregroundColor;
}

@end

