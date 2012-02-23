//
// Betwixt - Copyright 2012 Three Rings Design

#import "UIColor+Extensions.h"

@implementation UIColor (OOOExtensions)

+ (UIColor*)colorWithARGB:(uint)color {
    return [UIColor colorWithRed:SP_COLOR_PART_RED(color) / 255.0f 
                           green:SP_COLOR_PART_GREEN(color) / 255.0f 
                            blue:SP_COLOR_PART_BLUE(color) / 255.0f 
                           alpha:SP_COLOR_PART_ALPHA(color) / 255.0f];
}

@end
