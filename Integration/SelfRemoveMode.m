//
//  Betwixt - Copyright 2011 Three Rings Design

#import "SelfRemoveMode.h"

#import "BTModeStack.h"
#import "RAConnection.h"

@interface SelfRemoveObject : BTObject
@end
@implementation SelfRemoveObject

- (id)init {
    if (!(self = [super init])) return nil;
    __weak SelfRemoveObject* mySelf = self;
    [self.attached connectBlock:^ {
        [mySelf.conns addConnection:[mySelf.root.enterFrame withPriority:RA_DEFAULT_PRIORITY + 1
                       connectBlock:^ { [mySelf detach]; }]];
    }];
    return self;
}

@end

@implementation SelfRemoveMode

- (id)init {
    if (!(self = [super init])) return nil;
    SelfRemoveObject *remover = [[SelfRemoveObject alloc] init];
    __block BOOL detached = NO;
    [remover.detached connectBlock:^{ detached = YES; }];
    [self addObject:remover];
    [[self.enterFrame connectBlock:^ {
        NSAssert(detached, @"Remover removed");
        detached = NO;
        BTObject *holder = [[BTObject alloc] init];
        SelfRemoveObject *subremover = [[SelfRemoveObject alloc] init];
        [subremover.detached connectBlock:^{ detached = YES; }];
        [self addObject:holder];
        [holder addObject:subremover];
        [[self.enterFrame connectBlock:^ {
            NSAssert(detached, @"Subremover removed");
            [_stack popMode];
        }] once];
    }] once];
    return self;
}

@end
