//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTCancelable.h"

typedef void (^BTCancelBlock)();

@interface BTCanceler : NSObject <BTCancelable> {
@protected
    BTCancelBlock _block;
}
- (id)initWithBlock:(BTCancelBlock)block;
@end

@implementation BTCanceler
- (id)initWithBlock:(BTCancelBlock)block {
    if ((self = [super init])) {
        _block = [block copy];
    }
    return self;
}

- (void)cancel {
    if (_block != nil) {
        // ensure that the block can't be called twice
        BTCancelBlock block = _block;
        _block = nil;
        block();
    }
}
@end

@implementation BTCancelableFactory
+ (id<BTCancelable>)withBlock:(BTCancelBlock)cancelBlock {
    return [[BTCanceler alloc] initWithBlock:cancelBlock];
}
@end