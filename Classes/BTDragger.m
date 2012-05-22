//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDragger.h"
#import "BTNode+Protected.h"
#import "BTDisplayObject.h"
#import "BTMode.h"

@implementation BTDragger

- (void)attached {
    [self.conns onReactor:self.detached connectUnit:^{
        [self cancelDrag];
    }];
}

- (BOOL)dragging {
    return _dragReg != nil;
}

- (void)startDragWithTouch:(SPTouch*)touch {
    _dragReg = [self.mode.input registerListener:self];
    _start = [SPPoint pointWithX:touch.globalX y:touch.globalY];
    _touch = touch;
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
        [self onDragEnd:_current start:_start];
        [self stopDragWithSuccess:YES];
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