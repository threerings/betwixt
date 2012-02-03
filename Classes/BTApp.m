//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTApp.h"
#import "BTResourceManager.h"
#import "BTModeStack+Package.h"

#import "BTTextureResource.h"
#import "BTMovieResource.h"

// We override SPStage in order to handle our own input and update processing.
@interface BTStage : SPStage
@property(nonatomic,weak) BTApp *app;
@end

@implementation BTApp

+ (BTApp *)app {
    static BTApp *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

- (id)init {
    if (!(self = [super init])) {
        return nil;
    }
    _resourceMgr = [[BTResourceManager alloc] init];
    _modeStacks = [NSMutableArray array];
    return self;
}

- (BTModeStack *)setup:(UIWindow *)window {
    NSAssert(_view == nil, @"setup has already been called");

    // Setup Sparrow
    [BTStage setSupportHighResolutions:YES];
    BTStage *stage = [[BTStage alloc] init];
    stage.app = self;
    
    _view = [[SPView alloc] initWithFrame:window.bounds];
    _view.multipleTouchEnabled = YES;
    _view.stage = stage;
    // Framerate must be set after the stage has been attached to the view.
    _view.stage.frameRate = 60;
    [window addSubview:_view];

    // TODO - figure out why this is throwing an exception. Looks like an iOS 5 bug
    //[SPAudioEngine start];

    // Setup ResourceManager
    [_resourceMgr registerFactory:[BTTextureResource sharedFactory] forType:BTTEXTURE_RESOURCE_NAME];
    [_resourceMgr registerFactory:[BTMovieResource sharedFactory] forType:BTMOVIE_RESOURCE_NAME];

    return [self createModeStack]; // create default mode stack
}

- (void)cleanup {
    _resourceMgr = nil;
    _modeStacks = nil;
    _view = nil;
    //[SPAudioEngine stop];
}

- (void)start {
    [_view start];
}

- (void)stop {
    [_view stop];
}

- (void)update:(float)dt {
    for (BTModeStack *stack in _modeStacks) {
        [stack update:dt];
    }
}

- (float)framerate {
    return _view.stage.frameRate;
}

- (void)processTouches:(NSSet *)touches {
    
}

- (BTModeStack *)createModeStack {
    BTModeStack *stack = [[BTModeStack alloc] init];
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

- (void)processTouches:(NSSet *)touches {
    [super processTouches:touches];
    //[BTApp processTouches:touches];
}

@synthesize app;

@end
