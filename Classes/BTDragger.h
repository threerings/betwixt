//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTObject.h"
#import "BTInput.h"

@class BTDisplayObject;

@interface BTDragger : BTObject <BTTouchListener> {
@protected
    SPPoint* _start;
    SPPoint* _current;
    id<OOORegistration> _dragReg;
    SPTouch* _touch;
}

@property (nonatomic,readonly) BOOL dragging;

/// While a drag is in progress, no other displayObjects will receive touch events.
- (void)startDragWithTouch:(SPTouch*)touch;
- (void)cancelDrag;

/// subclasses should override these to do something
- (void)onDragStart:(SPPoint*)start;
- (void)onDragged:(SPPoint*)current start:(SPPoint*)start;
- (void)onDragEnd:(SPPoint*)current start:(SPPoint*)start;
- (void)onDragCanceled:(SPPoint*)last start:(SPPoint*)start;

@end
