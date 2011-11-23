//
//  Betwixt - Copyright 2011 Three Rings Design

#import "SPEventDispatcher.h"

typedef NSString OOOBlockToken;
typedef void (^OOOBlockListener)(SPEvent*);

@interface SPEventDispatcher (OOOBlockListener)
- (OOOBlockToken*)addEventListenerForType:(NSString*)eventType listener:(OOOBlockListener)listener;
- (void)removeListenerWithBlockToken:(OOOBlockToken*)token;
@end
