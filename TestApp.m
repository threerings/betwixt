//
// Betwixt - Copyright 2012 Three Rings Design

#import "TestApp.h"
#import "BTApp+Protected.h"
#import "SubObjectMode.h"
#import "PlayMovieMode.h"
#import "NamedNodeMode.h"
#import "MoveMode.h"
#import "RepeatingMode.h"
#import "Square.h"
#import "SelfRemoveMode.h"
#import "BTModeStack.h"
#import "GroupTestMode.h"
#import "LeakTestMode.h"

#import "BTLoadingMode.h"

@interface LoadingMode : BTLoadingMode
@end

@implementation LoadingMode

- (id)init {
    if (!(self = [super init])) return nil;
    [self addFiles:@"ResourceTest.xml", @"squaredance.xml", nil];
    [self.loadComplete connectUnit:^{
        [self.modeStack changeMode:[[NamedNodeMode alloc] init]];
        [self.modeStack pushMode:[[MoveMode alloc] init]];
        [self.modeStack pushMode:[[SelfRemoveMode alloc] init]];
        [self.modeStack pushMode:[[PlayMovieMode alloc] init]];
        [self.modeStack pushMode:[[RepeatingMode alloc] init]];
        [self.modeStack pushMode:[[SubObjectMode alloc] init]];
        [self.modeStack pushMode:[[GroupTestMode alloc] init]];
        [self.modeStack pushMode:[[LeakTestMode alloc] init]];
    }];
    return self;
}

@end

@implementation TestApp

- (void)run:(BTModeStack *)defaultStack {
    [defaultStack pushMode:[[LoadingMode alloc] init]];
}

@end
