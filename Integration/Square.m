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
    [self observeObject:self forKeyPath:@"added" withBlock:^(id obj, NSDictionary *change) {
        _quad = [SPQuad quadWithWidth:100 height:100];
        _quad.color = _color;
        _quad.x = 50;
        _quad.y = 50;
        [((BTMode*)self.root).sprite addChild:_quad];
        [self.conns addConnection:[self.root.enterFrame connectBlock:^{
            _quad.x += 1;
            if (_quad.x >= 52) { [self.parent removeObject:self]; }
        }]];
    }];
    [self observeObject:self forKeyPath:@"removed" withBlock:^(id obj, NSDictionary *change) { [((BTMode*)self.root).sprite removeChild:_quad]; }];
    return self;
}

- (NSArray*)names {
    return [NSArray arrayWithObject:_name];
}

@end
