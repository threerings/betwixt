//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTMode.h"
#import "BTModeStack.h"
#import "BTKeyed.h"
#import "BTMode+Package.h"

@implementation BTMode {
    RADoubleSignal *_enterFrame;
    SPSprite *_sprite;
    NSMutableDictionary *_keyedObjects;
}

- (id)init {
    if (!(self = [super init])) return nil;
    _sprite = [[SPSprite alloc] init];
    _enterFrame = [[RADoubleSignal alloc] init];
    _keyedObjects = [[NSMutableDictionary alloc] init];
    return self;
}

- (BTNode*)nodeForKey:(NSString*) key {
    return [_keyedObjects objectForKey:key];
}

- (BTMode*) root {
    return self;
}

- (void)displayNode:(BTNode<BTDisplayable>*)node {
    [self addNode:node];
    [_sprite addChild:node.display];
}

- (void) detach {
    [_stack popMode];
}

- (SPDisplayObject*)display {
    return _sprite;
}

@synthesize sprite=_sprite, enterFrame=_enterFrame;

@end

@implementation BTMode (package)

- (void)enterFrame:(SPEnterFrameEvent*)ev {
    [_enterFrame emitEvent:ev.passedTime];
}

- (void)addKeys:(BTNode<BTKeyed>*)node {
    for (NSString *key in ((id<BTKeyed>)node).keys) {
        NSAssert1(![_keyedObjects objectForKey:key], @"Object key '%@' already used", key);
        [_keyedObjects setObject:node forKey:key];
    }
}

@end
