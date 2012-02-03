//
// Betwixt - Copyright 2012 Three Rings Design

@class BTResourceManager;
@class BTModeStack;
@class SPView;

@interface BTApp : NSObject {
@protected
    SPView *_view;
    BTResourceManager *_resourceMgr;
    NSMutableArray *_modeStacks;
}

+ (BTApp *)app;

- (BTModeStack *)setup:(UIWindow *)window;
- (void)cleanup;
- (void)start;
- (void)stop;

- (BTModeStack *)createModeStack;

/// Returns the framerate that the app is currently running at
@property(nonatomic,readonly) float framerate;
@property(nonatomic,readonly) BTResourceManager *resourceManager;
@property(nonatomic,readonly) SPView *view;

@end
