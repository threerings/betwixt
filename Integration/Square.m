//
//  Betwixt - Copyright 2011 Three Rings Design

#import "Square.h"
#import "BTMode.h"

@implementation Square

- (id)initWithColor:(int)color {
    if (!(self = [super init])) return nil;
    _color = color;
    return self;
}

-(void) addedToGen {
    _quad = [SPQuad quadWithWidth:100 height:100];
    _quad.color = _color;
    _quad.x = 50;
    _quad.y = 50;
    [((BTMode*)_gen).sprite addChild:_quad];
}

-(void) removedFromGen {
    [((BTMode*)_gen).sprite removeChild:_quad];
}

-(void) advanceTime:(double)seconds {
    _quad.x += 1;
    if (_quad.x == 70) [self addDependentObject:[[Square alloc] initWithColor:0x00ff00]];
    if (_quad.x > 90) [_gen removeObject:self];
}

@end
