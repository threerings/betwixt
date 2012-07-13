//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTObject.h"
#import "BTInput.h"

@class BTViewObject;

@interface BTDragger : BTObject <BTTouchListener> {
@protected
    SPPoint* _start;
    SPPoint* _current;
    id<OOORegistration> _dragReg;
    SPTouch* _touch;
    double _startTime;
}

@property (nonatomic,readonly) BOOL dragging;

/// seconds since the start of the current drag
@property (nonatomic,readonly) float elapsedTime;

/// YES if the drag counts as a tap (determined by the amount of time the
/// touch has been active, and the distance it has moved)
@property (nonatomic,readonly) BOOL isTap;

/// While a drag is in progress, no other displayObjects will receive touch events.
- (void)startDragWithTouch:(SPTouch*)touch;
- (void)cancelDrag;

/// subclasses should override these to do something
- (void)onDragStart:(SPPoint*)start;
- (void)onDragged:(SPPoint*)current start:(SPPoint*)start;
- (void)onDragEnd:(SPPoint*)current start:(SPPoint*)start;
- (void)onDragCanceled:(SPPoint*)last start:(SPPoint*)start;

@end
