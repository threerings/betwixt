//
// Betwixt - Copyright 2012 Three Rings Design

#define BT_COMPOSE_ARGB(a,r,g,b) (((int)(a) << 24) | ((int)(r) << 16) | ((int)(g) << 8) | (int)(b))

/// Blends two colors. 'amount' specifies the percentage of color1 that will be use
uint32_t BTBlendARGB (uint32_t color1, uint32_t color2, float amount);

@interface BTDisplayUtil : NSObject

+ (SPImage*)fillCircleWithRadius:(float)radius color:(uint)color;
+ (SPQuad*)fillRectWithWidth:(float)width height:(float)height color:(uint)color;
+ (SPSprite*)lineRectWithWidth:(float)width height:(float)height color:(uint)color
                   outlineSize:(float)outlineSize;
+ (SPSprite*)fillRectWithWidth:(float)width height:(float)height color:(uint)color
                   outlineSize:(float)outlineSize outlineColor:(uint)outlineColor;
@end