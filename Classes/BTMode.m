//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTMode.h"
#import "BTModeStack.h"
#import "BTNamed.h"
#import "BTMode+Package.h"

@implementation BTMode {
    RADoubleSignal *_enterFrame;
}

- (id)init {
    if (!(self = [super init])) return nil;
    _sprite = [[SPSprite alloc] init];
    _children = [[NSMutableSet alloc] init];
    _namedObjects = [NSMutableDictionary dictionary];
    _enterFrame = [[RADoubleSignal alloc] init];
    return self;
}

- (BTNode*)nodeForName:(NSString*)name {
    return [_namedObjects objectForKey:name];
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

- (void)attachNode:(BTNode*)object {
    if ([object conformsToProtocol:@protocol(BTNamed)]) {
        for (NSString *name in ((id<BTNamed>)object).names) {
            NSAssert1(![_namedObjects objectForKey:name], @"Object name '%@' already used", name);
            [_namedObjects setObject:object forKey:name];
        }
    }
    [object.attached emit];
}

@end
