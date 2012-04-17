//
// Betwixt - Copyright 2012 Three Rings Design

@class BTMode;

@interface BTInputRegistration : NSObject
- (void)cancel;
@end

@protocol BTTouchListener
- (BOOL)onTouchStart:(SPTouch*)touch;
- (BOOL)onTouchMove:(SPTouch*)touch;
- (BOOL)onTouchEnd:(SPTouch*)touch;
@end

@interface BTInput : NSObject {
@protected
    SPDisplayObjectContainer* _root;
    NSMutableArray* _listeners;
    NSMutableSet *_currentTouches;
    int _touchIdCounter;
}

- (id)initWithRoot:(SPDisplayObjectContainer*)root;

- (void)processTouches:(NSSet*)touches;

- (BTInputRegistration*)registerListener:(id<BTTouchListener>)l;
- (void)removeAllListeners;

@end
