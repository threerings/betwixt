//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTApp.h"
#import "BTResourceManager.h"
#import "BTModeStack+Package.h"

#import "BTTextureResource.h"
#import "BTMovieResource.h"

static BTResourceManager *_resourceMgr = nil;
static NSMutableArray *_modeStacks = nil;
static SPView *_view;

@implementation BTApp

+ (void)onEnterFrame:(SPEnterFrameEvent *)ev {
    float dt = (float) ev.passedTime;
    for (BTModeStack *stack in _modeStacks) {
        [stack update:dt];
    }
}

+ (BTModeStack *)setup:(UIWindow *)window {
    static BOOL hasSetup = NO;
    NSAssert(!hasSetup, @"setup has already been called");
    hasSetup = YES;

    // Setup Sparrow
    [SPStage setSupportHighResolutions:YES];
    _view = [[SPView alloc] initWithFrame:window.bounds];
    _view.multipleTouchEnabled = YES;
    _view.stage = [[SPStage alloc] init];
    [_view.stage addEventListener:@selector(onEnterFrame:) atObject:self
                          forType:SP_EVENT_TYPE_ENTER_FRAME];
    [window addSubview:_view];

    // TODO - figure out why this is throwing an exception. Looks like an iOS 5 bug
    //[SPAudioEngine start];

    // Setup ResourceManager
    _resourceMgr = [[BTResourceManager alloc] init];
    [_resourceMgr registerFactory:[BTTextureResource sharedFactory] forType:BTTEXTURE_RESOURCE_NAME];
    [_resourceMgr registerFactory:[BTMovieResource sharedFactory] forType:BTMOVIE_RESOURCE_NAME];

    // Mode stacks
    _modeStacks = [NSMutableArray array];
    return [BTApp createModeStack]; // create default mode stack
}

+ (void)cleanup {
    _resourceMgr = nil;
    _modeStacks = nil;
    _view = nil;
    //[SPAudioEngine stop];
}

+ (void)start {
    [_view start];
}

+ (void)stop {
    [_view stop];
}

+ (BTResourceManager *)resourceManager {
    return _resourceMgr;
}

+ (SPView*)view {
    return _view;
}

+ (BTModeStack *)createModeStack {
    BTModeStack *stack = [[BTModeStack alloc] init];
    [_view.stage addChild:stack->_sprite];
    [_modeStacks addObject:stack];
    return stack;
}

@end
