//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTApp.h"
#import "BTApp+Protected.h"
#import "BTApp+Package.h"
#import "BTResourceManager.h"
#import "BTModeStack+Package.h"

#import "BTTextureResource.h"
#import "BTMovieResource.h"

static Class gClass = nil;
static BTApp* gInstance = nil;

// We override SPStage in order to handle our own input and update processing.
@interface BTStage : SPStage
@property(nonatomic,weak) BTApp* app;
@end

@implementation BTApp

+ (void)registerAppClass:(Class)theClass {
    NSAssert(gClass == nil, @"BTApp class has already been registered");
    gClass = theClass;
}

+ (void)create:(UIWindow*)window {
    @synchronized(self) {
        NSAssert(gInstance == nil, @"BTApp has already been created");
        NSAssert(gClass != nil, @"[BTApp registerAppClass:] has not been called");
        gInstance = [[gClass alloc] init];
    }
    gInstance->_window = window;
    [gInstance runInternal];
}

+ (BTApp*)app {
    return gInstance;
}

- (id)init {
    if (!(self = [super init])) {
        return nil;
    }
    _resourceMgr = [[BTResourceManager alloc] init];
    _modeStacks = [NSMutableArray array];
    return self;
}

- (void)runInternal {
    NSAssert(_view == nil, @"runInternal has already been called");

    // Setup Sparrow
    [BTStage setSupportHighResolutions:YES];
    BTStage* stage = [[BTStage alloc] init];
    stage.app = self;
    
    _view = [[SPView alloc] initWithFrame:_window.bounds];
    _view.multipleTouchEnabled = YES;
    _view.stage = stage;
    // Framerate must be set after the stage has been attached to the view.
    _view.stage.frameRate = 60;
    // Attach the view to the window
    _window.rootViewController.view = _view;

    // TODO - figure out why this is throwing an exception. Looks like an iOS 5 bug
    //[SPAudioEngine start];

    // Setup ResourceManager
    [_resourceMgr registerFactory:[BTTextureResource sharedFactory] forType:BTTEXTURE_RESOURCE_NAME];
    [_resourceMgr registerFactory:[BTMovieResource sharedFactory] forType:BTMOVIE_RESOURCE_NAME];
    
    // create default mode stack
    [self run:[self createModeStack]];
}

- (void)cleanup {
    _resourceMgr = nil;
    _modeStacks = nil;
    _view = nil;
    //[SPAudioEngine stop];
}

- (void)run:(BTModeStack*)defaultStack {
    NSLog(@"BTApp.run must be implemented by a subclass");
    [self doesNotRecognizeSelector:_cmd];
}

- (void)appDidBecomeActive {
    [_view start];
}

- (void)appWillResignActive {
    [_view stop];
}

- (void)update:(float)dt {
    for (BTModeStack* stack in _modeStacks) {
        [stack update:dt];
    }
}

- (float)framerate {
    return _view.stage.frameRate;
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

@synthesize resourceManager=_resourceMgr, view=_view;

@end

@implementation BTStage

- (void)advanceTime:(double)seconds {
    [self.app update:(float) seconds];
}

- (void)processTouches:(NSSet*)touches {
    [self.app processTouches:touches];
}

@synthesize app;

@end
