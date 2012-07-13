//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDragger.h"
#import "BTApp.h"
#import "BTNode+Protected.h"
#import "BTViewObject.h"
#import "BTMode.h"
#import "SPPoint+BTExtensions.h"

static const float MAX_TAP_TIME = 0.5f;
static const float MAX_TAP_MOVEMENT = 10;

@implementation BTDragger

- (void)added {
    [self.conns onReactor:self.removed connectUnit:^{
        [self cancelDrag];
    }];
}

- (BOOL)dragging {
    return _dragReg != nil;
}

- (float)elapsedTime {
    return (self.dragging ? (float) (BTApp.timeNow - _startTime) : 0);
}

- (BOOL)isTap {
    if (self.dragging && self.elapsedTime <= MAX_TAP_TIME) {
        return [SPPoint distanceSqFromPoint:_current toPoint:_start] <= 
            (MAX_TAP_MOVEMENT * MAX_TAP_MOVEMENT);
    }
    return NO;
}

- (void)startDragWithTouch:(SPTouch*)touch {
    _dragReg = [self.mode.input registerListener:self];
    _start = [SPPoint pointWithX:touch.globalX y:touch.globalY];
    _current = [_start copy];
    _touch = touch;
    _startTime = _touch.timestamp;
    [self onDragStart:_start];
}

- (BOOL)onTouchStart:(SPTouch*)touch {
    return self.dragging;
}

- (BOOL)onTouchMove:(SPTouch*)touch {
    if (!self.dragging) {
        return NO;
    }
    if (touch == _touch) {
        _current = [SPPoint pointWithX:touch.globalX y:touch.globalY];
        [self onDragged:_current start:_start];
    }
    return YES;
}

- (BOOL)onTouchEnd:(SPTouch*)touch {
    if (!self.dragging) {
        return NO;
    }
    if (touch == _touch) {
        _current = [SPPoint pointWithX:touch.globalX y:touch.globalY];
        // stop the drag before calling onDragEnd, to allow safe destruction of the 
        // dragger from within onDragEnd
        [self stopDragWithSuccess:YES];
        [self onDragEnd:_current start:_start];
    }
    return YES;
}

- (void)cancelDrag {
    [self stopDragWithSuccess:NO];
}

- (void)stopDragWithSuccess:(BOOL)dragCompleted {
    if (_dragReg != nil) {
        [_dragReg cancel];
        _dragReg = nil;
        if (!dragCompleted) {
            [self onDragCanceled:(_current != nil ? _current : _start) start:_start];
        }
    }
}

- (void)onDragStart:(SPPoint*)start {}
- (void)onDragged:(SPPoint*)current start:(SPPoint*)start {}
- (void)onDragEnd:(SPPoint*)current start:(SPPoint*)start {}
- (void)onDragCanceled:(SPPoint*)last start:(SPPoint*)start {}

@end