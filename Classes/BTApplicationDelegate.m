//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTApplicationDelegate.h"
#import "BTApp.h"

@implementation BTApplicationDelegate

- (id)init {
    if (!(self = [super init])) return nil;
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.rootViewController = [[UIViewController alloc] init];
    return self;
}

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BTModeStack* defaultStack = [BTApp.app setup:_window];
    [_window makeKeyAndVisible];
    [self run:defaultStack];
    [BTApp.app start];
    return YES;
}

- (void)run:(BTModeStack *)defaultStack {
    NSLog(@"Games should kick off their initial BTMode from this function");
}

- (void)applicationWillResignActive:(UIApplication*)application {
    [BTApp.app stop];
}

- (void)applicationDidBecomeActive:(UIApplication*)application {
	[BTApp.app start];
}

- (void)dealloc {
    [BTApp.app cleanup];
}

@end
