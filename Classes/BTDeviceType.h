//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTEnum.h"

@interface BTDeviceType : BTEnum

+ (BTDeviceType*)IPHONE;
+ (BTDeviceType*)IPHONE_RETINA;
+ (BTDeviceType*)IPAD;
+ (BTDeviceType*)IPAD_RETINA;

@property(nonatomic,readonly) int screenWidth;
@property(nonatomic,readonly) int screenHeight;

@end
