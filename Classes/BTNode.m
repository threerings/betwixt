//
// Betwixt - Copyright 2011 Three Rings Design

#import "BTNode.h"
#import "BTNode+Package.h"
#import "BTContext.h"
#import "BTGeneration.h"

@implementation BTNode

-  (id)init {
    if (!(self = [super init])) return nil;
    _attached = [[RAUnitSignal alloc] init];
    _detached = [[RAUnitSignal alloc] init];
    _conns = [[RAConnectionGroup alloc] init];
    return self;
}

- (void)detach {
    [_parent removeNode:self];
}

- (BTGeneration*) root {
    if ([_parent isKindOfClass:[BTGeneration class]]) return (BTGeneration*)_parent;
    return _parent.root;
}

@synthesize parent=_parent, conns=_conns, attached=_attached, detached=_detached;
@end

@implementation BTNode (package)

- (void)removeInternal {
    _parent = nil;
    [self.detached emit];
    [_attached disconnectAll];
    [_detached disconnectAll];
    [_conns disconnectAll];
}

@end
