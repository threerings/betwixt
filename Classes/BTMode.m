//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTMode.h"

@implementation BTMode

- (id)init {
    if ((self = [super init])) {
        _sprite = [[SPSprite alloc] init];
    }
    return self;
}

@synthesize sprite=_sprite;

@end
