//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPEventDispatcher.h"

typedef NSString OOOBlockToken;
typedef void (^OOOBlockListener)(SPEvent *event);

@interface SPEventDispatcher (OOOBlockListener)
- (OOOBlockToken*)addEventListenerForType:(NSString*)eventType listener:(OOOBlockListener)listener;
- (void)removeListenerWithBlockToken:(OOOBlockToken*)token;
@end
