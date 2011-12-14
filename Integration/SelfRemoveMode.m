//
//  Betwixt - Copyright 2011 Three Rings Design

#import "SelfRemoveMode.h"

#import "BTModeStack.h"

@interface SelfRemoveObject : BTObject
@end
@implementation SelfRemoveObject

- (id)init {
    if (!(self = [super init])) return nil;
    __weak SelfRemoveObject* mySelf = self;
    [self observeObject:self forKeyPath:@"added" withBlock:^(id obj, NSDictionary *change) {
        [self listenToDispatcher:mySelf.root forEvent:SP_EVENT_TYPE_ENTER_FRAME withBlock:^(SPEvent *event) {
            [mySelf.parent removeObject:mySelf];
        }];
    }];
    return self;
}

@end

@implementation SelfRemoveMode

- (id)init {
    if (!(self = [super init])) return nil;
    SelfRemoveObject *remover = [[SelfRemoveObject alloc] init];
    [self addObject:remover];
    __block NSString *token = [self listenToDispatcher:self forEvent:SP_EVENT_TYPE_ENTER_FRAME withBlock:^(SPEvent *event) {
        NSAssert(remover.removed == YES, @"Remover removed");
        [self removeListenerWithBlockToken:token];
        BTObject *holder = [[BTObject alloc] init];
        [self addObject:holder];
        SelfRemoveObject *subremover = [[SelfRemoveObject alloc] init];
        [holder addObject:subremover];
        [self listenToDispatcher:self forEvent:SP_EVENT_TYPE_ENTER_FRAME withBlock:^(SPEvent *event) {
            NSAssert(subremover.removed == YES, @"Subremover removed");
            [_stack popMode];
        }];
    }];
    return self;
}

@end
