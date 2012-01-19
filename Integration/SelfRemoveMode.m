//
//  Betwixt - Copyright 2011 Three Rings Design

#import "SelfRemoveMode.h"

#import "BTDetachTask.h"
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
    [self detach];
}

@end

@implementation SelfRemoveMode

- (void)testDestroyParentTask {
    __block BOOL detached = NO;
    BTObject *holder = [[BTObject alloc] init];
    [holder.detached connectUnit:^{ detached = YES; }];
    [self addNode:holder];
    [holder addNode:[BTDetachTask detachParent]];
    [[self.update connectUnit:^ {
        NSAssert(detached, @"Parent removed");
        [self detach];
    }] once];
}

- (void)testSubobjectRemoval {
    __block BOOL detached = NO;
    BTObject *holder = [[BTObject alloc] init];
    SelfRemoveObject *subremover = [[SelfRemoveObject alloc] init];
    [subremover.detached connectUnit:^{ detached = YES; }];
    [self addNode:holder];
    [holder addNode:subremover];
    [[self.update connectUnit:^ {
        NSAssert(detached, @"Subremover removed");
        [self testDestroyParentTask];
    }] once];
}

- (id)init {
    if (!(self = [super init])) return nil;
    SelfRemoveObject *remover = [[SelfRemoveObject alloc] init];
    __block BOOL detached = NO;
    [remover.detached connectUnit:^{ detached = YES; }];
    [self addNode:remover];
    [[self.update connectUnit:^ {
        NSAssert(detached, @"Remover removed");
        [self testSubobjectRemoval];
    }] once];
    return self;
}

@end
