//
// Betwixt - Copyright 2011 Three Rings Design

#import "BTBlockTask.h"
#import "BTGeneration.h"

@implementation BTBlockTask

- (id)initWithBlock:(BTTaskBlock)block {
    if (!(self = [super init])) return nil;
    [self.attached connectUnit:^{
        [self.conns addConnection:[self.root.enterFrame connectUnit:^{ block(self); }]];
    }];
    return self;
}

+ (BTBlockTask*)withBlock:(BTTaskBlock)block {
    return [[BTBlockTask alloc] initWithBlock:block];
}
@end
