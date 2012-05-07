//
// Betwixt - Copyright 2012 Three Rings Design

#import "OOOEnum.h"

@interface BTDeviceType : OOOEnum

+ (BTDeviceType*)IPHONE;
+ (BTDeviceType*)IPHONE_RETINA;
+ (BTDeviceType*)IPAD;
+ (BTDeviceType*)IPAD_RETINA;
+ (BTDeviceType*)NOD_TEMP;

@property(nonatomic,readonly) int screenWidth;
@property(nonatomic,readonly) int screenHeight;
@property(nonatomic,readonly) NSString* deviceClass;
@property(nonatomic,readonly) BOOL retina;

@end
