//
//  Betwixt - Copyright 2011 Three Rings Design

#import "TestApplicationDelegate.h"
#import "Game.h"
#import "Square.h"

@implementation TestApplicationDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    if (![super application:application didFinishLaunchingWithOptions:launchOptions]) return NO;
    _game = [[Game alloc] init];
    [self.defaultStack pushMode:_game];
    [SPStage.mainStage addEventListener:@selector(runTest:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    return YES;
}

- (void)checkForSquareAdded:(SPEnterFrameEvent*)ev {
    [SPStage.mainStage removeEventListener:@selector(checkForSquareAdded:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    NSAssert(_game.squaresAdded == 1, @"Square not added by first tick by Game");
}

int _framesSeen = 0;

- (void)runTest:(SPEnterFrameEvent*)ev {
    if(++_framesSeen % 10 == 0) {
        [_game runTest];
        [SPStage.mainStage addEventListener:@selector(checkForSquareAdded:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    }
}

@end
