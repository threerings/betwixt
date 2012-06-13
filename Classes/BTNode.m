//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTNode.h"
#import "BTNode+Package.h"
#import "BTNode+Protected.h"
#import "BTMode.h"

@implementation BTNode

- (void)added {
}

- (void)cleanup {
}

- (void)removeSelf {
    [_parent removeNode:self];
}

- (BTMode*)mode {
    return _parent.mode;
}

- (RAUnitSignal*)removed {
    if (_removed == nil) _removed = [[RAUnitSignal alloc] init];
    return _removed;
}

- (RAConnectionGroup*)conns {
    if (_conns == nil) _conns = [[RAConnectionGroup alloc] init];
    return _conns;
}

- (void)addedInternal {
    [self added];
}

- (void)removedInternal {
    _parent = nil;
    [_removed emit];
    [self cleanupInternal];
}

- (void)cleanupInternal {
    [self cleanup];
    [_removed disconnectAll];
    [_conns disconnectAll];
    _wasRemoved = YES;
}

- (BOOL)isLive {
    return (_parent != nil);
}

- (NSArray*)keys {
    return nil;
}

- (NSArray*)groups {
    return nil;
}

- (NSObject<BTNodeContainer>*)parent {
    return (_parent.isLive ? _parent : nil);
}

@end