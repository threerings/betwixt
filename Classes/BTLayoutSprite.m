//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTLayoutSprite.h"

@implementation BTLayoutSprite
- (void)layoutDisplayObjects:(NSArray*)objects {
    OOO_IS_ABSTRACT();
}
@end

@implementation BTRowLayoutSprite

- (id)initWithVAlign:(SPVAlign)align gap:(float)gap {
    if ((self = [super init])) {
        _align = align;
        _gap = gap;
    }
    return self;
}

- (void)layoutDisplayObjects:(NSArray*)objects {
    [self removeAllChildren];

    // lay out in a row
    float xOffset = 0;
    float maxHeight = 0;
    for (SPDisplayObject* disp in objects) {
        SPRectangle* bounds = disp.bounds;
        disp.x = -bounds.x + xOffset;
        disp.y = -bounds.y;
        [self addChild:disp];

        xOffset += bounds.width + _gap;
        maxHeight = MAX(maxHeight, bounds.height);
    }

    // apply vertical alignment
    if (_align != SPVAlignTop) {
        for (SPDisplayObject* disp in objects) {
            float yDiff = maxHeight - disp.height;
            disp.y += (_align == SPVAlignBottom ? yDiff : yDiff * 0.5f);
        }
    }
}

@end

@implementation BTColumnLayoutSprite

- (id)initWithHAlign:(SPHAlign)align gap:(float)gap {
    if ((self = [super init])) {
        _align = align;
        _gap = gap;
    }
    return self;
}

- (void)layoutDisplayObjects:(NSArray*)objects {
    [self removeAllChildren];

    // lay out in a column
    float yOffset = 0;
    float maxWidth = 0;
    for (SPDisplayObject* disp in objects) {
        SPRectangle* bounds = disp.bounds;
        disp.x = -bounds.x;
        disp.y = -bounds.y + yOffset;
        [self addChild:disp];

        yOffset += bounds.height + _gap;
        maxWidth = MAX(maxWidth, bounds.width);
    }

    // apply horizontal alignment
    if (_align != SPHAlignLeft) {
        for (SPDisplayObject* disp in objects) {
            float xDiff = maxWidth - disp.width;
            disp.x += (_align == SPHAlignRight ? xDiff : xDiff * 0.5f);
        }
    }
}

@end

