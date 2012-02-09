//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTApp.h"

@interface BTApp (protected)

- (void)run:(BTModeStack*)defaultStack;
- (void)cleanup;

- (void)update:(float)dt;
- (void)processTouches:(NSSet*)touches;

- (void)appDidBecomeActive;
- (void)appWillResignActive;

@end
