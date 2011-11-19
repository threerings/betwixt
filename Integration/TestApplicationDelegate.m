//
//  Betwixt - Copyright 2011 Three Rings Design

#import "TestApplicationDelegate.h"
#import "Game.h"
#import "Square.h"

@implementation TestApplicationDelegate

- (void)applicationDidFinishLaunching:(UIApplication*)application {
    [super applicationDidFinishLaunching:application];
    [self.defaultStack pushMode:[[Game alloc] init]];
    [SPStage.mainStage addEventListener:@selector(checkForSquareAdded:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
}

- (void)checkForSquareAdded:(SPEnterFrameEvent*)ev {
    [SPStage.mainStage removeEventListener:@selector(checkForSquareAdded:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    NSAssert(SQUARES_ADDED == 1, @"Square not added on first tick by Game");
}

@end
