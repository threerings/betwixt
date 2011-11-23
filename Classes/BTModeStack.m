//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTModeStack.h"

#import "BTGeneration+Package.h"

@implementation BTModeStack

- (id)init {
    if (!(self = [super init])) return nil;
    _sprite = [[SPSprite alloc] init];
    _stack = [NSMutableArray array];
    return self;
}

- (void)pushMode:(BTMode*)mode {
    [_stack addObject:mode];
    [_sprite addChild:mode.sprite];
}
@end

@implementation BTModeStack (package)

- (void)enterFrame:(SPEnterFrameEvent *)ev {
    for (BTMode *mode in _stack) [mode enterFrame:ev];
}

@end