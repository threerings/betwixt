//
// Betwixt - Copyright 2012 Three Rings Design

#import "Square.h"
#import "BTNode+Protected.h"
#import "BTMode.h"
#import "SPEventDispatcher+BlockListener.h"

@implementation Square

- (id)initWithColor:(int)color andName:(NSString *)name {
    if (!(self = [super init])) return nil;
    _name = name;
    _quad = [SPQuad quadWithWidth:100 height:100 color:color];
    _quad.x = 50;
    _quad.y = 50;
    _attached = [[RAUnitSignal alloc] init];
    [self.detached connectUnit:^ { [((BTMode*)self.mode).sprite removeChild:_quad]; }];
    return self;
}

- (void)attached {
    [super attached];
    [_attached emit];
}

- (void)update:(float)dt {
    _quad.x += 1;
    if (_quad.x >= 52) { [self detach]; }
}

- (NSArray*)groups {
    return BT_STATIC_GROUPS(@"squares");
}

- (NSArray*)keys {
    return BT_KEYS(_name);
}

@synthesize display=_quad, onAttached=_attached;

@end
