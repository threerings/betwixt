//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTApp.h"
#import "BTApp+Protected.h"
#import "BTApp+Package.h"
#import "BTResourceManager.h"
#import "BTModeStack+Package.h"

#import "BTAtlasFactory.h"
#import "BTTextureResource.h"
#import "BTMovieResource.h"

static BTApp* gInstance = nil;

// We override SPStage in order to handle our own input and update processing.
@interface BTStage : SPStage
@property(nonatomic,weak) BTApp* app;
@end

@interface BTViewController : UIViewController
- (id)initWithApp:(BTApp*)app;
@end
@implementation BTViewController {
    __weak BTApp* _app;
}

- (id)initWithApp:(BTApp *)app {
    if (!(self = [super init])) return nil;
    _app = app;
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return [_app supportsUIInterfaceOrientation:toInterfaceOrientation];
}

@end

@implementation BTApp {
@protected
    UIWindow* _window;
    BTViewController* _viewController;
    SPView* _view;
    SPPoint* _viewSize;
    
    BTResourceManager* _resourceMgr;
    NSMutableArray* _modeStacks;
    
    float _framerate;
}

+ (BTApp*)app {
    return gInstance;
}

- (id)init {
    NSAssert(gInstance == nil, @"BTApp has already been created");
    if (!(self = [super init])) return nil;
    gInstance = self;
    return self;
}

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    
    // Window
    CGRect windowBounds = [UIScreen mainScreen].bounds;
    _window = [[UIWindow alloc] initWithFrame:windowBounds];
    _viewController = [[BTViewController alloc] initWithApp:self];
    _window.rootViewController = _viewController;
    
    CGRect viewBounds = windowBounds;
    if (![self supportsUIInterfaceOrientation:UIInterfaceOrientationPortrait] &&
        ![self supportsUIInterfaceOrientation:UIInterfaceOrientationPortraitUpsideDown]) {
        CGFloat tmp = viewBounds.size.width;
        viewBounds.size.width = viewBounds.size.height;
        viewBounds.size.height = tmp;
    }
    
    // View
    _view = [[SPView alloc] initWithFrame:viewBounds];
    _view.multipleTouchEnabled = YES;
    _viewController.view = _view;
    
    // // Stage
    [BTStage setSupportHighResolutions:YES];
    BTStage* stage = [[BTStage alloc] initWithWidth:viewBounds.size.width 
                                             height:viewBounds.size.height];
    stage.app = self;
    _view.stage = stage;
    // Framerate must be set after the stage has been attached to the view.
    stage.frameRate = 60;
    
    _viewSize = [SPPoint pointWithX:stage.width y:stage.height];
    
    // TODO - figure out why this is throwing an exception. Looks like an iOS 5 bug
    //[SPAudioEngine start];
    
    // Setup ResourceManager
    _resourceMgr = [[BTResourceManager alloc] init];
    [_resourceMgr registerFactory:[BTTextureResource sharedFactory] forType:BTTEXTURE_RESOURCE_NAME];
    [_resourceMgr registerFactory:[BTMovieResource sharedFactory] forType:BTMOVIE_RESOURCE_NAME];
    [_resourceMgr registerMultiFactory:[BTAtlasFactory sharedFactory] forType:BTATLAS_RESOURCE_NAME];
    
    // create default mode stack
    _modeStacks = [NSMutableArray array];
    [self run:[self createModeStack]];
    
    [_window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication*)application {
    [_view stop];
}

- (void)applicationDidBecomeActive:(UIApplication*)application {
    [_view start];
}

- (void)dealloc {
    _resourceMgr = nil;
    _modeStacks = nil;
    _view = nil;
    //[SPAudioEngine stop];
}

- (void)run:(BTModeStack*)defaultStack {
    NSLog(@"BTApp.run must be implemented by a subclass");
    [self doesNotRecognizeSelector:_cmd];
}

- (void)update:(float)dt {
    _framerate = 1.0f / dt;
    for (BTModeStack* stack in _modeStacks) {
        [stack update:dt];
    }
}

- (float)framerate {
    return _framerate;
}

- (void)processTouches:(NSSet*)touches {
    for (BTModeStack* stack in _modeStacks) {
        [stack processTouches:touches];
    }
}

- (BTModeStack*)createModeStack {
    BTModeStack* stack = [[BTModeStack alloc] init];
    [_view.stage addChild:stack->_sprite];
    [_modeStacks addObject:stack];
    return stack;
}

- (BOOL)supportsUIInterfaceOrientation:(UIInterfaceOrientation)orientation {
    return UIInterfaceOrientationIsPortrait(orientation);
}

@synthesize resourceManager=_resourceMgr, view=_view, viewSize=_viewSize;

@end

@implementation BTStage

- (void)advanceTime:(double)seconds {
    [self.juggler advanceTime:seconds];
    [self.app update:(float) seconds];
}

- (void)processTouches:(NSSet*)touches {
    [self.app processTouches:touches];
}

@synthesize app;

@end
