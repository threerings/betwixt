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
    [self observeObject:self forKeyPath:@"added" withBlock:^(id obj, NSDictionary *change) {
        [mySelf.root.enterFrame connectBlock:^ { [mySelf.parent removeObject:mySelf]; }];
    }];
    return self;
}

@end

@implementation SelfRemoveMode

- (id)init {
    if (!(self = [super init])) return nil;
    SelfRemoveObject *remover = [[SelfRemoveObject alloc] init];
    [[self.enterFrame connectBlock:^ {
        NSAssert(remover.removed == YES, @"Remover removed");
        BTObject *holder = [[BTObject alloc] init];
        SelfRemoveObject *subremover = [[SelfRemoveObject alloc] init];
        [[self.enterFrame connectBlock:^ {
            NSAssert(subremover.removed == YES, @"Subremover removed");
            [_stack popMode];
        }] once];
        [self addObject:holder];
        [holder addObject:subremover];
    }] once];
    [self addObject:remover];
    return self;
}

@end
