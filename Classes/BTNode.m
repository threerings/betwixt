//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTNode.h"
#import "BTNode+Package.h"
#import "BTNode+Protected.h"
#import "BTMode.h"

@implementation BTNode

- (void)attachedInternal {
    [self attached];
}

- (void)attached {
}

- (void)detach {
    [_parent removeNode:self];
}

- (BTMode*)mode {
    return _parent.mode;
}

- (RAUnitSignal*)detached {
    if (_detached == nil) _detached = [[RAUnitSignal alloc] init];
    return _detached;
}

- (RAConnectionGroup*)conns {
    if (_conns == nil) _conns = [[RAConnectionGroup alloc] init];
    return _conns;
}

- (void)removeInternal {
    _parent = nil;
    [_detached emit];
    [self cleanup];
}

- (void)cleanup {
    [_detached disconnectAll];
    [_conns disconnectAll];
    _isDetached = YES;
}

- (BOOL)isAttached {
    return (_parent != nil);
}

- (NSArray*)keys {
    return nil;
}

- (NSArray*)groups {
    return nil;
}

@synthesize parent=_parent, isDetached=_isDetached;

@end