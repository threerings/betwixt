//
//  Betwixt - Copyright 2011 Three Rings Design

#import "TestApplicationDelegate.h"
#import "SubObjectMode.h"
#import "NamedNodeMode.h"
#import "MoveMode.h"
#import "Square.h"
#import "SelfRemoveMode.h"
#import "BTResourceManager.h"

#import "SPEventDispatcher+BlockListener.h"

@implementation TestApplicationDelegate {
    SubObjectMode *_adder;
}

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    if (![super application:application didFinishLaunchingWithOptions:launchOptions]) return NO;
    
    // load resources
    [[BTResourceManager sharedManager] pendResourceFile:@"ResourceTest.xml"];
    [[BTResourceManager sharedManager] loadPendingResources:^{ 
                                                      NSLog(@"onComplete");
                                                  } onError:^(NSException *err) {
                                                      NSLog(@"onError: %@", err);
                                                  }];
    
    [self.defaultStack pushMode:[[NamedNodeMode alloc] init]];
    [self.defaultStack pushMode:[[MoveMode alloc] init]];
    [self.defaultStack pushMode:[[SelfRemoveMode alloc] init]];
    _adder = [[SubObjectMode alloc] init];
    [self.defaultStack pushMode:_adder];
    [SPStage.mainStage addEventListener:@selector(checkForSquareAdded:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    return YES;
}

- (void)checkForSquareAdded:(SPEnterFrameEvent*)ev {
    [SPStage.mainStage removeEventListener:@selector(checkForSquareAdded:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    NSAssert(_adder.squaresAdded == 1, @"Square not added by first tick by Game");
    _adder = nil;
}

@end
