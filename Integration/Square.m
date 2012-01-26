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
    [self.detached connectUnit:^ { [((BTMode*)self.mode).sprite removeChild:_quad]; }];
    return self;
}

- (void)update:(float)dt {
    _quad.x += 1;
    if (_quad.x >= 52) { [self detach]; }
}

- (NSArray*)keys {
    return [NSArray arrayWithObject:_name];
}

@synthesize display=_quad;

@end
