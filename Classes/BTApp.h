//
//  Betwixt - Copyright 2012 Three Rings Design

@class BTResourceManager;
@class BTModeStack;

@interface BTApp : NSObject

+ (BTModeStack *)setup:(UIWindow *)window;
+ (void)cleanup;
+ (void)start;
+ (void)stop;

+ (BTResourceManager *)resourceManager;
+ (BTModeStack *)createModeStack;

@end
