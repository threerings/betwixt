//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTSimpleTextButton.h"
#import "BTButton+Protected.h"
#import "SPTextField+BTExtensions.h"

static const float PADDING = 4;
static const uint BG_COLOR_UP = 0x6699CC;
static const uint BG_COLOR_DOWN = 0x0F3792;
static const uint TEXT_COLOR_UP = 0x0F3792;
static const uint TEXT_COLOR_DOWN = 0x6699CC;

@implementation BTSimpleTextButton

- (id)initWithText:(NSString*)text fontSize:(float)size {
    if ((self = [super init])) {
        _container = [[SPSprite alloc] init];
        [_sprite addChild:_container];

        _tf = [[SPTextField alloc] init];
        _tf.fontSize = size;
        _tf.color = TEXT_COLOR_UP;
        [_tf autoSizeText:text];
        _tf.x = PADDING;
        _tf.y = PADDING;

        // draw a rectangle
        _bg = [[SPQuad alloc] initWithWidth:_tf.width + (PADDING * 2)
                                     height:_tf.height + (PADDING * 2)];
        _bg.color = BG_COLOR_UP;

        [_container addChild:_bg];
        [_container addChild:_tf];

        _clickBounds = [_container bounds];
    }
    return self;
}

- (SPRectangle*)clickBounds {
    return _clickBounds;
}

- (void)displayState:(BTButtonState)state {
    _bg.color = (state == BT_ButtonDown ? BG_COLOR_DOWN : BG_COLOR_UP);
    _tf.color = (state == BT_ButtonDown ? TEXT_COLOR_DOWN : TEXT_COLOR_UP);

    _container.alpha = (state == BT_ButtonDisabled ? 0.4f : 1.0f);
}

@end
