//
// Betwixt - Copyright 2012 Three Rings Design

#import "LeakTestMode.h"
#import "BTMode+Protected.h"
#import "BTObject.h"
#import "BTNode+Protected.h"
#import "BTModeStack.h"
#import "BTUpdatable.h"
#import "BTSpriteObject.h"
#import "BTResourceManager.h"
#import "BTMovieResource.h"
#import "BTMovie.h"
#import "BTApp.h"

@interface Updater : BTObject <BTUpdatable>
@end
@implementation Updater
- (void)update:(float)dt {}
@end

@interface Listener : BTObject
@property(nonatomic,assign) int ticks;
@end

@implementation Listener
@synthesize ticks;
- (void)added {
    [self.conns onFloatReactor:self.mode.update connectSlot:^(float dt) { self.ticks++; }];
}
@end

@implementation LeakTestMode

- (void)setup {
    BTObject* parent = [[BTObject alloc] init];
    BTObject* child = [[BTObject alloc] init];
    [self addNode:parent];
    [parent addNode:child];
    [parent removeSelf];
    _parent = parent;
    _child = child;
    
    BTObject* parent2 = [[BTObject alloc] init];
    BTObject* child2 = [[BTObject alloc] init];
    [parent2 addNode:child2];
    [self addNode:parent2];
    [child2 removeSelf];
    _child2 = child2;
    
    Updater* updater = [[Updater alloc] init];
    [self addNode:updater];
    [updater removeSelf];
    _updater = updater;
    
    Listener* listener = [[Listener alloc] init];
    [self addNode:listener];
    _listener = listener;
    
    BTSpriteObject* sprite = [BTSpriteObject sprite];
    [self addNode:sprite displayOn:self.sprite];
    [sprite removeSelf];
    _sprite = sprite;
    
    BTMovie *movie = [[BTApp.resourceManager requireResource:@"squaredance"] newMovie];
    BTSpriteObject* movieSprite = [BTSpriteObject withSprite:movie];
    [self addNode:movieSprite displayOn:self.sprite];
    [movieSprite removeSelf];
    _movie = movie;
}

- (void)update:(float)dt {
    [super update:dt];
    _ticks++;
    if (_ticks == 2) {
        NSAssert(_parent == nil, @"Parent leaked");
        NSAssert(_child == nil, @"Child leaked");
        NSAssert(_child2 == nil, @"Child2 leaked");
        NSAssert(_updater == nil, @"Updater leaked");
        NSAssert(_sprite == nil, @"Sprite leaked");
        NSAssert(_movie == nil, @"Movie leaked");
        [_listener removeSelf];
    } else if (_ticks == 3) {
        NSAssert(_listener == nil, @"Listener leaked");
        [self.modeStack popMode];
    }
}

@end
