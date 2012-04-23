//
// Betwixt - Copyright 2012 Three Rings Design

@class BTResourceManager;
@class BTModeStack;
@class SPView;
@class BTDeviceType;
@class BTViewController;

@interface BTApp : NSObject <UIApplicationDelegate> {
@protected
    UIWindow* _window;
    BTViewController* _viewController;
    SPView* _view;
    SPPoint* _viewSize;
    
    BTDeviceType* _deviceType;
    
    BTResourceManager* _resourceMgr;
    NSMutableArray* _modeStacks;
    
    float _framerate;
}

+ (BTApp*)app;
- (BTModeStack*)createModeStack;
- (NSString*)resourcePathFor:(NSString*)resourceName;

/// the framerate that the app is currently running at
@property (nonatomic,readonly) float framerate;
@property (nonatomic,readonly) BTResourceManager* resourceManager;
@property (nonatomic,readonly) SPView* view;
@property (nonatomic,readonly) SPPoint* viewSize;
@property (nonatomic,readonly) BTDeviceType* deviceType;
/// current absolute time in seconds
@property (nonatomic,readonly) double timeNow;

@end
