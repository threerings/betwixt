//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDisplayUtil.h"
#import "UIColor+BTExtensions.h"

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

@implementation BTDisplayUtil

+ (SPImage*)fillCircleWithRadius:(float)radius color:(uint)color {
    int size = (int) ceil(radius * 2);

    SPTexture* tex = [[SPTexture alloc] initWithWidth:size height:size draw:^(CGContextRef ctx) {
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithARGB:color | 0xff000000].CGColor);
        CGContextFillEllipseInRect(ctx, CGRectMake(0, 0, size, size));
    }];

    SPImage* img = [[SPImage alloc] initWithTexture:tex];
    img.pivotX = radius;
    img.pivotY = radius;
    return img;
}

+ (SPQuad*)fillRectWithWidth:(float)width height:(float)height color:(uint)color {
    SPQuad* quad = [[SPQuad alloc] initWithWidth:width height:height];
    quad.color = color;
    return quad;
}

+ (SPSprite*)lineRectWithWidth:(float)width height:(float)height color:(uint)color
                   outlineSize:(float)outlineSize {

    return [BTDisplayUtil fillRectWithWidth:width height:height color:0 outlineSize:outlineSize
                             outlineColor:color];
}

+ (SPSprite*)fillRectWithWidth:(float)width height:(float)height color:(uint)color
                   outlineSize:(float)outlineSize outlineColor:(uint)outlineColor {

    SPSprite* sprite = [SPSprite sprite];

    if (color != 0) {
        [sprite addChild:[BTDisplayUtil fillRectWithWidth:width height:height color:color]];
    }
    SPQuad* top = [BTDisplayUtil fillRectWithWidth:width height:outlineSize color:outlineColor];
    SPQuad* bottom = [BTDisplayUtil fillRectWithWidth:width height:outlineSize color:outlineColor];
    SPQuad* left = [BTDisplayUtil fillRectWithWidth:outlineSize height:height color:outlineColor];
    SPQuad* right = [BTDisplayUtil fillRectWithWidth:outlineSize height:height color:outlineColor];

    bottom.y = height - outlineSize;
    right.x = width - outlineSize;

    [sprite addChild:top];
    [sprite addChild:bottom];
    [sprite addChild:left];
    [sprite addChild:right];
    return sprite;
}

@end