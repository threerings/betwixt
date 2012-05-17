//
// Betwixt - Copyright 2012 Three Rings Design

@class BTResourceManager;
@class BTAudioManager;
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
    BTAudioManager* _audio;
    NSMutableArray* _modeStacks;
    
    float _framerate;
}

+ (BTApp*)app;
+ (float)framerate;
+ (BTResourceManager*)resourceManager;
+ (BTAudioManager*)audio;
+ (SPView*)view;
+ (SPPoint*)viewSize;
+ (BTDeviceType*)deviceType;
/// current absolute time in seconds
+ (double)timeNow;

+ (BTModeStack*)createModeStack;
/// Returns the path for the given resource file.
+ (NSString*)resourcePathFor:(NSString*)resourceName;
/// Returns the path for the given resource file. Throws an exception if the file does not exist. 
+ (NSString*)requireResourcePathFor:(NSString*)resourceName;

@end
