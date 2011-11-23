//
//  Betwixt - Copyright 2011 Three Rings Design

#import "Square.h"
#import "BTMode.h"
#import "NSObject+BlockObservation.h"
#import "SPEventDispatcher+BlockListener.h"

@implementation Square

- (id)initWithColor:(int)color andName:(NSString *)name {
    if (!(self = [super init])) return nil;
    _color = color;
    _name = name;
    OBSERVE(self, self, @"added", {
        _quad = [SPQuad quadWithWidth:100 height:100];
        _quad.color = _color;
        _quad.x = 50;
        _quad.y = 50;
        [((BTMode*)_gen).sprite addChild:_quad];
        [self listenTo:_gen forEvent:SP_EVENT_TYPE_ENTER_FRAME withBlock:^(SPEvent* event) {
            _quad.x += 1;
            if (_quad.x > 52) [_gen removeObject:self];
        }];
    });
    OBSERVE(self, self, @"removed", { [((BTMode*)_gen).sprite removeChild:_quad]; });
    return self;
}

- (NSArray*)names {
    return [NSArray arrayWithObject:_name];
}

@end
