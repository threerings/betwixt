//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTApplicationDelegate.h"
#import "BTApp+Protected.h"
#import "BTApp+Package.h"

@implementation BTApplicationDelegate

- (id)init {
    if (!(self = [super init])) return nil;
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.rootViewController = [[UIViewController alloc] init];
    return self;
}

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    [BTApp create:_window];
    [_window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication*)application {
    [BTApp.app appWillResignActive];
}

- (void)applicationDidBecomeActive:(UIApplication*)application {
	[BTApp.app appDidBecomeActive];
}

- (void)dealloc {
    [BTApp.app cleanup];
}

@end
