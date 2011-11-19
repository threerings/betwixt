//
//  Betwixt - Copyright 2011 Three Rings Design

#import "Square.h"
#import "BTMode.h"

@implementation Square

- (id)initWithColor:(int)color andName:(NSString *)name {
    if (!(self = [super init])) return nil;
    _color = color;
    _name = name;
    return self;
}

- (NSArray*)names {
    return [NSArray arrayWithObject:_name];
}

- (void)addedToGen {
    _quad = [SPQuad quadWithWidth:100 height:100];
    _quad.color = _color;
    _quad.x = 50;
    _quad.y = 50;
    [((BTMode*)_gen).sprite addChild:_quad];
    SQUARES_ADDED++;
}

- (void)removedFromGen {
     [((BTMode*)_gen).sprite removeChild:_quad];
    SQUARES_REMOVED++;
}

- (void)advanceTime:(double)seconds {
    _quad.x += 1;
    if (_quad.x > 52) [_gen removeObject:self];
}

@end
