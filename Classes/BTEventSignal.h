//
// Betwixt - Copyright 2012 Three Rings Design

#import "RAObjectSignal.h"

/// Redispatches an SPEvent as a signal
@interface BTEventSignal : RAObjectSignal {
@protected
    __weak SPEventDispatcher* _dispatcher;
    NSString* _eventType;
    BOOL _connected;
}

+ (BTEventSignal*)eventSignalWithDispatcher:(SPEventDispatcher*)dispatcher eventType:(NSString*)eventType;
+ (BTEventSignal*)touchEventSignalWithDisplayObject:(SPDisplayObject*)disp;

- (id)initWithDispatcher:(SPEventDispatcher*)dispatcher eventType:(NSString*)eventType;

- (RAConnection*)withPriority:(int)priority connectSlot:(RAObjectSlot)block;

@end
