//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTModeStack.h"

@implementation BTModeStack

- (id)init
{
    if ((self = [super init])) {
        _sprite = [[SPSprite alloc] init];
    }
    return self;
}

- (void)pushMode:(BTMode *)mode 
{
    [_sprite addChild:mode.sprite];
}

- (void)advanceTime:(double)seconds {
}

@end