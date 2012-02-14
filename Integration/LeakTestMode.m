//
// Betwixt - Copyright 2012 Three Rings Design

#import "LeakTestMode.h"
#import "BTMode+Protected.h"
#import "BTObject.h"
#import "BTNode+Protected.h"
#import "BTModeStack.h"
#import "BTUpdatable.h"

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
- (void)attached {
    [self.conns onFloatReactor:self.mode.update connectSlot:^(float dt) {
        self.ticks++;
        NSLog(@"Listener.ticks: %d", self.ticks);
    }];
}
@end

@implementation LeakTestMode {
    __weak BTObject* _parent;
    __weak BTObject* _child;
    __weak BTObject* _child2;
    __weak Updater* _updater;
    __weak Listener* _listener;
    int _ticks;
}

- (void)setup {
    BTObject* parent = [[BTObject alloc] init];
    BTObject* child = [[BTObject alloc] init];
    [self addNode:parent];
    [parent addNode:child];
    
    _parent = parent;
    _child = child;
    [parent detach];
    
    BTObject* parent2 = [[BTObject alloc] init];
    BTObject* child2 = [[BTObject alloc] init];
    [parent2 addNode:child2];
    [self addNode:parent2];
    
    [child2 detach];
    
    _child2 = child2;
    
    Updater* updater = [[Updater alloc] init];
    [self addNode:updater];
    [updater detach];
    _updater = updater;
    
    Listener* listener = [[Listener alloc] init];
    [self addNode:listener];
    
    _listener = listener;
}

- (void)update:(float)dt {
    [super update:dt];
    _ticks++;
    if (_ticks == 2) {
        NSAssert(_parent == nil, @"Parent leaked");
        NSAssert(_child == nil, @"Child leaked");
        NSAssert(_child2 == nil, @"Child2 leaked");
        NSAssert(_updater == nil, @"Updater leaked");
        [_listener detach];
    } else if (_ticks == 3) {
        NSAssert(_listener == nil, @"Listener leaked");
        [self.stack popMode];
    }
}

@end
