//
//  Bangalaclang - Copyright 2011 Three Rings Design

#import "BCMode.h"

@implementation BCMode

- (id)init
{
    if ((self = [super init])) {
        _sprite = [[SPSprite alloc] init];
    }
    return self;
}

@synthesize sprite=_sprite;

@end
