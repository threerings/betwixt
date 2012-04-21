//
// Betwixt - Copyright 2012 Three Rings Design

/// Represents something that can be canceled
@protocol BTCancelable
- (void)cancel;
@end

@interface BTCancelableFactory
/// Creates a BTCancelable object that calls the given block when canceled.
/// The block is guaranteed to only be called once, even if cancel() is called
/// multiple times.
+ (id<BTCancelable>)withBlock:(void(^)())cancelBlock;
@end
