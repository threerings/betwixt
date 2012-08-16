//
// Betwixt - Copyright 2012 Three Rings Design

#import "UIColor+BTExtensions.h"

#define BT_COLOR_PART_ALPHA(color)  (((color) >> 24) & 0xff)
#define BT_COLOR_PART_RED(color)    (((color) >> 16) & 0xff)
#define OOO_COLOR_PART_GREEN(color)  (((color) >>  8) & 0xff)
#define OOO_COLOR_PART_BLUE(color)   ( (color)        & 0xff)

@implementation UIColor (BTExtensions.h)

+ (UIColor*)colorWithARGB:(uint)color {
    return [UIColor colorWithRed:SP_COLOR_PART_RED(color) / 255.0f
                           green:SP_COLOR_PART_GREEN(color) / 255.0f
                            blue:SP_COLOR_PART_BLUE(color) / 255.0f
                           alpha:SP_COLOR_PART_ALPHA(color) / 255.0f];
}

@end
