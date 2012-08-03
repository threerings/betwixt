//
// Betwixt - Copyright 2012 Three Rings Design

@class BTMode;
@protocol OOORegistration;

typedef enum {
    BTTouch_Unhandled = 0,
    BTTouch_Handled
} BTTouchStatus;

/// A TouchListener receives touch events and returns a status
/// specifying whether it handled the event. Unhandled events
/// are passed to the next TouchListener on the stack; handled
/// events are considered finished.
@protocol BTTouchListener
- (BTTouchStatus)onTouchStart:(SPTouch*)touch;
- (BTTouchStatus)onTouchMove:(SPTouch*)touch;
- (BTTouchStatus)onTouchEnd:(SPTouch*)touch;
@end

@interface BTInput : NSObject {
@protected
    SPDisplayObjectContainer* _root;
    NSMutableArray* _listeners;
    NSMutableSet *_currentTouches;
}

- (id)initWithRoot:(SPDisplayObjectContainer*)root;

- (void)processTouches:(NSSet*)touches;

/// Adds a listener to the BTInput. Listeners are placed on a stack,
/// so the most recently added listener gets the first chance at
/// each touch event.
- (id<OOORegistration>)registerListener:(id<BTTouchListener>)l;

- (void)removeAllListeners;

@end
