//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDeviceType.h"

@interface BTDeviceType ()
- (id)initWithScreenWidth:(int)screenWidth screenHeight:(int)screenHeight deviceClass:(NSString*)deviceClass retina:(BOOL)retina;
@end

@implementation BTDeviceType {
    int _screenWidth;
    int _screenHeight;
    NSString* _deviceClass;
    BOOL _retina;
}

BT_ENUM_INIT(IPHONE, [[BTDeviceType alloc] initWithScreenWidth:480 screenHeight:320 deviceClass:@"iPhone" retina:NO]);
BT_ENUM_INIT(IPHONE_RETINA, [[BTDeviceType alloc] initWithScreenWidth:960 screenHeight:640 deviceClass:@"iPhone" retina:YES]);
BT_ENUM_INIT(IPAD, [[BTDeviceType alloc] initWithScreenWidth:1024 screenHeight:768 deviceClass:@"iPad" retina:NO]);
BT_ENUM_INIT(IPAD_RETINA, [[BTDeviceType alloc] initWithScreenWidth:2048 screenHeight:1536 deviceClass:@"iPad" retina:YES]);
BT_ENUM_INIT(NOD_TEMP, [[BTDeviceType alloc] initWithScreenWidth:960.0f*2.67f screenHeight:640.0f*2.67f deviceClass:@"iPhone" retina:YES]);

- (id)initWithScreenWidth:(int)screenWidth screenHeight:(int)screenHeight deviceClass:(NSString*)deviceClass retina:(BOOL)retina {
    if (!(self = [super init])) {
        return nil;
    }
    _screenWidth = screenWidth;
    _screenHeight = screenHeight;
    _deviceClass = deviceClass;
    _retina = retina;
    return self;
}

@synthesize screenWidth=_screenWidth, screenHeight=_screenHeight, deviceClass=_deviceClass, retina=_retina;

@end
