//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDeviceType.h"

@interface BTDeviceType ()
- (id)initWithScreenWidth:(int)screenWidth screenHeight:(int)screenHeight;
@end

@implementation BTDeviceType {
    int _screenWidth;
    int _screenHeight;
}

BT_ENUM_INIT(IPHONE, [[BTDeviceType alloc] initWithScreenWidth:480 screenHeight:320]);
BT_ENUM_INIT(IPHONE_RETINA, [[BTDeviceType alloc] initWithScreenWidth:960 screenHeight:640]);
BT_ENUM_INIT(IPAD, [[BTDeviceType alloc] initWithScreenWidth:1024 screenHeight:768]);
BT_ENUM_INIT(IPAD_RETINA, [[BTDeviceType alloc] initWithScreenWidth:2048 screenHeight:1536]);
BT_ENUM_INIT(NOD_TEMP, [[BTDeviceType alloc] initWithScreenWidth:960.0f*2.67f screenHeight:640.0f*2.67f]);

- (id)initWithScreenWidth:(int)screenWidth screenHeight:(int)screenHeight {
    if (!(self = [super init])) {
        return nil;
    }
    _screenWidth = screenWidth;
    _screenHeight = screenHeight;
    return self;
}

@synthesize screenWidth=_screenWidth, screenHeight=_screenHeight;

@end
