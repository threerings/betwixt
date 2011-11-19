//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTModeStack.h"

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

- (void)advanceTime:(double)seconds {
    for (BTMode *mode in _stack) [mode advanceTime:seconds];
}

@end