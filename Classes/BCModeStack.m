//
//  Bangalaclang - Copyright 2011 Three Rings Design

#import "BCModeStack.h"

@implementation BCModeStack

- (id)init
{
    if ((self = [super init])) {
        _sprite = [[SPSprite alloc] init];
    }
    return self;
}

- (void)pushMode:(BCMode *)mode 
{
    [_sprite addChild:mode.sprite];
}

@end