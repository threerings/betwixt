//
// nod - Copyright 2012 Three Rings Design

#import "BTObject.h"
#import "BTInput.h"

@class BTDisplayObject;

typedef void (^BTDragStartBlock)(SPPoint* start);
typedef void (^BTDraggedBlock)(SPPoint* current, SPPoint* start);

/// Listens for touches on the given target.
/// When the target is touched, a drag will start.
/// While a drag is in progress, no other displayObjects will receive touch events.

@interface BTDragger : BTObject <BTTouchListener> {
@protected
    __weak BTDisplayObject* _target;
    SPPoint* _start;
    SPPoint* _current;
    RAConnection* _touchBeganConn;
    BTInputRegistration* _dragReg;
}

@property (nonatomic,assign) BOOL enabled; // default: YES
@property (nonatomic,readonly) BOOL dragging;

+ (BTDragger*)withTarget:(BTDisplayObject*)target 
             onDragStart:(BTDragStartBlock)onDragStart
               onDragged:(BTDraggedBlock)onDragged
               onDragEnd:(BTDraggedBlock)onDragEnd;

/// Designated initializer
- (id)initWithTarget:(BTDisplayObject*)target enabled:(BOOL)enabled;
- (id)initWithTarget:(BTDisplayObject*)target;

- (void)cancelDrag;

/// subclasses should override these to do something
- (void)onDragStart:(SPPoint*)start;
- (void)onDragged:(SPPoint*)current start:(SPPoint*)start;
- (void)onDragEnd:(SPPoint*)current start:(SPPoint*)start;

@end
