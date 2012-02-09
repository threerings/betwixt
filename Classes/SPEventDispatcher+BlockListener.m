//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPEventDispatcher+BlockListener.h"
#import <objc/runtime.h>

@interface OOOListenerTrampoline :NSObject {
    @public
    OOOBlockListener _listener;
    NSString* _type;
}
- (OOOListenerTrampoline*)initListeningTo:(SPEventDispatcher*)dispatcher forType:(NSString*)type withListener:(OOOBlockListener)listener;
- (void)dispatch:(SPEvent*)event;
- (void)disconnect;
@end

@implementation OOOListenerTrampoline

-(OOOListenerTrampoline*)initListeningTo:(SPEventDispatcher*)dispatcher forType:(NSString*)type withListener:(OOOBlockListener)listener {
    if (!(self = [super init])) return nil;
    _type = type;
    _listener = [listener copy];
    return self;
}

-(void)dispatch:(SPEvent*)event {
    if (_listener) _listener(event);
}
-(void)disconnect {
    _listener = nil;
}
@end

static NSString* OOOListenerMap = @"com.threerings.listenerMap";

@implementation SPEventDispatcher (OOOBlockListener)

-(OOOBlockToken*)addEventListenerForType:(NSString*)eventType listener:(OOOBlockListener)listener {
    OOOBlockToken* token = [[NSProcessInfo processInfo] globallyUniqueString];
    NSMutableDictionary* dict = objc_getAssociatedObject(self, (__bridge const void*)OOOListenerMap);
    if (!dict) {
        dict = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, (__bridge const void*)OOOListenerMap, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    OOOListenerTrampoline* trampoline = [[OOOListenerTrampoline alloc] initListeningTo:self forType:eventType withListener:listener];
    [dict setObject:trampoline forKey:token];
    [self addEventListener:@selector(dispatch:) atObject:trampoline forType:eventType retainObject:YES];
    return token;
}

-(void)removeListenerWithBlockToken:(OOOBlockToken*)token {
    NSMutableDictionary* dict = objc_getAssociatedObject(self, (__bridge const void*)OOOListenerMap);
    OOOListenerTrampoline* trampoline = [dict objectForKey:token];
    if (!trampoline) return;
    [trampoline disconnect];
    [self removeEventListenersAtObject:trampoline forType:trampoline->_type];
    [dict removeObjectForKey:token];
    if ([dict count] == 0) {
        objc_setAssociatedObject(self, (__bridge const void*)OOOListenerMap, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
