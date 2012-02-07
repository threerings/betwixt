//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTDragger.h"

@interface BTCallbackDragger : BTDragger
@property(nonatomic,assign) BTDragStartBlock onDragStart;
@property(nonatomic,assign) BTDraggedBlock onDragged;
@property(nonatomic,assign) BTDraggedBlock onDragEnd;
@end

@implementation BTCallbackDragger

@synthesize onDragStart, onDragged, onDragEnd;

- (void)onDragStart:(SPPoint *)start {
    if (onDragStart != nil) {
        onDragStart(start);
    }
}

- (void)onDragged:(SPPoint *)current start:(SPPoint *)start {
    if (onDragged != nil) {
        onDragged(current, start);
    }
}

- (void)onDragEnd:(SPPoint *)current start:(SPPoint *)start {
    if (onDragEnd != nil) {
        onDragEnd(current, start);
    }
}

@end

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

+ (BTDragger *)onDragStart:(BTDragStartBlock)onDragStart onDragged:(BTDraggedBlock)onDragged 
                 onDragEnd:(BTDraggedBlock)onDragEnd {
    BTCallbackDragger *dragger = [[BTCallbackDragger alloc] init];
    dragger.onDragStart = onDragStart;
    dragger.onDragged = onDragged;
    dragger.onDragEnd = onDragEnd;
    return dragger;
}

@end
