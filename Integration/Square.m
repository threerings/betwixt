//
//  Betwixt - Copyright 2011 Three Rings Design

#import "Square.h"
#import "BTMode.h"
#import "SPEventDispatcher+BlockListener.h"

@implementation Square

- (id)initWithColor:(int)color andName:(NSString *)name {
    if (!(self = [super init])) return nil;
    _name = name;
    _quad = [SPQuad quadWithWidth:100 height:100 color:color];
    _quad.x = 50;
    _quad.y = 50;
    [self.attached connectUnit:^ {
        [self.conns addConnection:[self.root.enterFrame withPriority:SQUARE_FRAME_PRIORITY
            connectUnit:^{
            _quad.x += 1;
            if (_quad.x >= 52) { [self detach]; }
        }]];
    }];
    [self.detached connectUnit:^ { [((BTMode*)self.root).sprite removeChild:_quad]; }];
    return self;
}

- (NSArray*)keys {
    return [NSArray arrayWithObject:_name];
}

@synthesize display=_quad;

@end
