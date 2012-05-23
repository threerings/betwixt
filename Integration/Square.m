//
// Betwixt - Copyright 2012 Three Rings Design

#import "Square.h"
#import "BTNode+Protected.h"
#import "BTMode.h"

@implementation Square

- (id)initWithColor:(int)color andName:(NSString *)name {
    if (!(self = [super init])) return nil;
    _name = name;
    _quad = [SPQuad quadWithWidth:100 height:100 color:color];
    _quad.x = 50;
    _quad.y = 50;
    _added = [[RAUnitSignal alloc] init];
    [self.removed connectUnit:^ { [((BTMode*)self.mode).sprite removeChild:_quad]; }];
    return self;
}

- (void)added {
    [super added];
    [_added emit];
}

- (void)update:(float)dt {
    _quad.x += 1;
    if (_quad.x >= 52) { [self removeSelf]; }
}

- (NSArray*)groups {
    return BT_STATIC_GROUPS(@"squares");
}

- (NSArray*)keys {
    return BT_KEYS(_name);
}

@synthesize display=_quad, onAdded=_added;

@end
