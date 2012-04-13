//
// nod - Copyright 2012 Three Rings Design

#import "BTDragger.h"
#import "BTNode+Protected.h"
#import "BTDisplayObject.h"
#import "BTMode.h"

@implementation BTDragger {
    BTInputRegistration* _draggerReg;
}

- (void)cleanup {
    [self cancelDrag];
    [super cleanup];
}

- (BOOL)dragging {
    return _draggerReg != nil;
}

- (void)startDragWithTouch:(SPTouch*)touch {
    [self startDragWithScreenLoc:[SPPoint pointWithX:touch.globalX y:touch.globalY]];
}

- (void)startDragWithScreenLoc:(SPPoint*)globalLoc {
    _draggerReg = [self.mode.input registerListener:self];
    _start = [globalLoc copy];
    [self onDragStart:_start];
}

- (BOOL)onTouchStart:(SPPoint*)globalPt {
    // this should never get called.
    return NO;
}

- (BOOL)onTouchMove:(SPPoint*)globalPt {
    if (!self.dragging) {
        return NO;
    }
    _current = [globalPt copy];
    [self onDragged:_current start:_start];
    return YES;
}

- (BOOL)onTouchEnd:(SPPoint*)globalPt {
    if (!self.dragging) {
        return NO;
    }
    _current = [globalPt copy];
    [self onDragEnd:_current start:_start];
    [self cancelDrag];
    return YES;
}

- (void)cancelDrag {
    [_draggerReg cancel];
    _draggerReg = nil;
}

- (void)onDragStart:(SPPoint*)start {}
- (void)onDragged:(SPPoint*)current start:(SPPoint*)start {}
- (void)onDragEnd:(SPPoint*)current start:(SPPoint*)start {}

@end