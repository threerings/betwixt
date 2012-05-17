//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDeviceType.h"

@interface BTDeviceType () {
@protected
    int _screenWidth;
    int _screenHeight;
    NSString* _deviceClass;
    BOOL _retina;
}
- (id)initWithScreenWidth:(int)screenWidth screenHeight:(int)screenHeight deviceClass:(NSString*)deviceClass retina:(BOOL)retina;
@end

@implementation BTDeviceType

@synthesize screenWidth = _screenWidth;
@synthesize screenHeight = _screenHeight;
@synthesize deviceClass = _deviceClass;
@synthesize retina = _retina;

OOO_ENUM_INIT(IPHONE, [[BTDeviceType alloc] initWithScreenWidth:480 screenHeight:320 deviceClass:@"iPhone" retina:NO]);
OOO_ENUM_INIT(IPHONE_RETINA, [[BTDeviceType alloc] initWithScreenWidth:960 screenHeight:640 deviceClass:@"iPhone" retina:YES]);
OOO_ENUM_INIT(IPAD, [[BTDeviceType alloc] initWithScreenWidth:1024 screenHeight:768 deviceClass:@"iPad" retina:NO]);
OOO_ENUM_INIT(IPAD_RETINA, [[BTDeviceType alloc] initWithScreenWidth:2048 screenHeight:1536 deviceClass:@"iPad" retina:YES]);
OOO_ENUM_INIT(NOD_TEMP, [[BTDeviceType alloc] initWithScreenWidth:960.0f*2.67f screenHeight:640.0f*2.67f deviceClass:@"iPhone" retina:YES]);

- (id)initWithScreenWidth:(int)screenWidth screenHeight:(int)screenHeight deviceClass:(NSString*)deviceClass retina:(BOOL)retina {
    if ((self = [super init])) {
        _screenWidth = screenWidth;
        _screenHeight = screenHeight;
        _deviceClass = deviceClass;
        _retina = retina;
    }
    return self;
}
@end
