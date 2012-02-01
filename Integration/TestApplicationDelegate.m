//
// Betwixt - Copyright 2012 Three Rings Design

#import "TestApplicationDelegate.h"
#import "SubObjectMode.h"
#import "PlayMovieMode.h"
#import "NamedNodeMode.h"
#import "MoveMode.h"
#import "RepeatingMode.h"
#import "Square.h"
#import "SelfRemoveMode.h"

#import "BTLoadingMode.h"

@interface LoadingMode : BTLoadingMode
@end

@implementation LoadingMode

- (id)init {
    if (!(self = [super init])) return nil;
    [self addFiles:@"ResourceTest.xml", @"squaredance.xml", nil];
    [self.loadComplete connectUnit:^{
        [self.stack changeMode:[[NamedNodeMode alloc] init]];
        [self.stack pushMode:[[MoveMode alloc] init]];
        [self.stack pushMode:[[SelfRemoveMode alloc] init]];
        [self.stack pushMode:[[PlayMovieMode alloc] init]];
        [self.stack pushMode:[[RepeatingMode alloc] init]];
        [self.stack pushMode:[[SubObjectMode alloc] init]];
    }];
    return self;
}

@end

@implementation TestApplicationDelegate

- (void)run:(BTModeStack *)defaultStack {
    [defaultStack pushMode:[[LoadingMode alloc] init]];
}

@end
