//
// Betwixt - Copyright 2012 Three Rings Design

#import "SelfRemoveMode.h"

#import "BTRemoveTask.h"
#import "BTModeStack.h"
#import "BTObject.h"
#import "RAConnection.h"
#import "BTUpdatable.h"

@interface SelfRemoveObject : BTObject<BTUpdatable>
@end
@implementation SelfRemoveObject

- (id)init {
    if (!(self = [super init])) return nil;
    return self;
}

- (void)update:(float)dt {
    [self removeSelf];
}

@end

@implementation SelfRemoveMode

- (void)testDestroyParentTask {
    __block BOOL removed = NO;
    BTObject *holder = [[BTObject alloc] init];
    [holder.removed connectUnit:^{ removed = YES; }];
    [self addNode:holder];
    [holder addNode:[BTRemoveTask removeNode]];
    [[self.update connectUnit:^ {
        NSAssert(removed, @"Parent removed");
        [self.modeStack popMode];
    }] once];
}

- (void)testSubobjectRemoval {
    __block BOOL removed = NO;
    BTObject *holder = [[BTObject alloc] init];
    SelfRemoveObject *subremover = [[SelfRemoveObject alloc] init];
    [subremover.removed connectUnit:^{ removed = YES; }];
    [self addNode:holder];
    [holder addNode:subremover];
    [[self.update connectUnit:^ {
        NSAssert(removed, @"Subremover removed");
        [self testDestroyParentTask];
    }] once];
}

- (id)init {
    if (!(self = [super init])) return nil;
    SelfRemoveObject *remover = [[SelfRemoveObject alloc] init];
    __block BOOL removed = NO;
    [remover.removed connectUnit:^{ removed = YES; }];
    [self addNode:remover];
    [[self.update connectUnit:^ {
        NSAssert(removed, @"Remover removed");
        [self testSubobjectRemoval];
    }] once];
    return self;
}

@end
