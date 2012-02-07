//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDragger.h"

@implementation BTDragger

- (id)init {
    if (!(self = [super init])) {
        return nil;
    }
    _start = [SPPoint point];
    _current = [SPPoint point];
    return self;
}

- (void)onDragStart:(SPPoint *)start {}
- (void)onDragged:(SPPoint *)current start:(SPPoint *)start {}
- (void)onDragEnd:(SPPoint *)current start:(SPPoint *)start {}

- (void)onTouchStart:(SPPoint *)globalPt {
    _start.x = globalPt.x;
    _start.y = globalPt.y;
    [self onDragStart:_start];
}

- (void)onTouchMove:(SPPoint *)globalPt {
    _current.x = globalPt.x;
    _current.y = globalPt.y;
    [self onDragged:_current start:_start];
}

- (void)onTouchEnd:(SPPoint *)globalPt {
    _current.x = globalPt.x;
    _current.y = globalPt.y;
    [self onDragEnd:_current start:_start];
}

@end
