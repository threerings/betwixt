//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTApp.h"

@interface BTApp (protected)

- (void)run:(BTModeStack*)defaultStack;

- (void)update:(float)dt;
- (void)processTouches:(NSSet*)touches;

- (UIImage*)loadSplashImage:(UIInterfaceOrientation)orientation;
- (BOOL)supportsUIInterfaceOrientation:(UIInterfaceOrientation)orientation;

- (NSString*)resourcePathPrefix;

@end
