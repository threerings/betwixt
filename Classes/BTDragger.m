//
// nod - Copyright 2012 Three Rings Design

#import "BTDragger.h"
#import "BTNode+Protected.h"
#import "BTDisplayObject.h"
#import "BTMode.h"

@implementation BTDragger

- (void)cleanup {
    [self cancelDrag];
    [super cleanup];
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
        [self cancelDrag];
    }
    return YES;
}

- (void)cancelDrag {
    [_dragReg cancel];
    _dragReg = nil;
}

- (void)onDragStart:(SPPoint*)start {}
- (void)onDragged:(SPPoint*)current start:(SPPoint*)start {}
- (void)onDragEnd:(SPPoint*)current start:(SPPoint*)start {}

@end