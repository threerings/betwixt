//
//  Bangalaclang - Copyright 2011 Three Rings Design

#import "TestApplicationDelegate.h"
#import "Game.h"

@implementation TestApplicationDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    [super applicationDidFinishLaunching:application];
    [mSparrowView.stage addChild:[[Game alloc] init]];
}

@end
