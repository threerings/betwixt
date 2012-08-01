//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayUtil.h"

uint32_t BTBlendARGB (uint32_t color1, uint32_t color2, float amount) {
    if (amount <= 0) {
        return color2;
    } else if (amount >= 1) {
        return color1;
    }

    float inv = 1.0f - amount;
    float a = (amount * (float) SP_COLOR_PART_ALPHA(color1)) + (inv * (float) SP_COLOR_PART_ALPHA(color2));
    float r = (amount * (float) SP_COLOR_PART_RED(color1))  + (inv * (float) SP_COLOR_PART_RED(color2));
    float g = (amount * (float) SP_COLOR_PART_GREEN(color1)) + (inv * (float) SP_COLOR_PART_GREEN(color2));
    float b = (amount * (float) SP_COLOR_PART_BLUE(color1)) + (inv * (float) SP_COLOR_PART_BLUE(color2));
    return BT_COMPOSE_ARGB(a, r, g, b);
}