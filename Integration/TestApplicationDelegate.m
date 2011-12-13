//
//  Betwixt - Copyright 2011 Three Rings Design

#import "TestApplicationDelegate.h"
#import "Game.h"
#import "Square.h"

#import "SPEventDispatcher+BlockListener.h"

@implementation TestApplicationDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    if (![super application:application didFinishLaunchingWithOptions:launchOptions]) return NO;
    [self.defaultStack pushMode:[[Game alloc] init]];
    [self.defaultStack pushMode:[[Game alloc] init]];
     _game = [[Game alloc] init];
    [self.defaultStack pushMode:_game];
    [SPStage.mainStage addEventListener:@selector(checkForSquareAdded:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    return YES;
}

- (void)checkForSquareAdded:(SPEnterFrameEvent*)ev {
    [SPStage.mainStage removeEventListener:@selector(checkForSquareAdded:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    NSAssert(_game.squaresAdded == 1, @"Square not added by first tick by Game");
}

@end
