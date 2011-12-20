//
//  Betwixt - Copyright 2011 Three Rings Design

#import "SelfRemoveMode.h"

#import "BTDestroyParentTask.h"
#import "BTModeStack.h"
#import "RAConnection.h"

@interface SelfRemoveObject : BTObject
@end
@implementation SelfRemoveObject

- (id)init {
    if (!(self = [super init])) return nil;
    __weak SelfRemoveObject* mySelf = self;
    [self.attached connectUnit:^ {
        [mySelf.conns addConnection:[mySelf.root.enterFrame withPriority:RA_DEFAULT_PRIORITY + 1
                       connectUnit:^ { [mySelf detach]; }]];
    }];
    return self;
}

@end

@implementation SelfRemoveMode

- (void)testDestroyParentTask {
    __block BOOL detached = NO;
    BTObject *holder = [[BTObject alloc] init];
    [holder.detached connectUnit:^{ detached = YES; }];
    [self addNode:holder];
    [holder addNode:[[BTDestroyParentTask alloc] init]];
    [[self.enterFrame connectUnit:^ {
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
    [[self.enterFrame connectUnit:^ {
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
    [[self.enterFrame connectUnit:^ {
        NSAssert(detached, @"Remover removed");
        [self testSubobjectRemoval];
    }] once];
    return self;
}

@end
