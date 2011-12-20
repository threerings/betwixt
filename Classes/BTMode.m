//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTMode.h"

@implementation BTMode

- (id)init {
    if (!(self = [super init])) return nil;
    _sprite = [[SPSprite alloc] init];
    return self;
}

- (SPDisplayObject*)display {
    return _sprite;
}

@synthesize sprite=_sprite;

@end
