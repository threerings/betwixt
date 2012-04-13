//
// nod - Copyright 2012 Three Rings Design

#import "BTDragger.h"
#import "BTNode+Protected.h"
#import "BTDisplayObject.h"
#import "BTMode.h"

@interface BTCallbackDragger : BTDragger
@property(nonatomic,copy) BTDragStartBlock onDragStart;
@property(nonatomic,copy) BTDraggedBlock onDragged;
@property(nonatomic,copy) BTDraggedBlock onDragEnd;
@end

@implementation BTDragger {
    BTInputRegistration* _draggerReg;
}

+ (BTDragger*)withTarget:(BTDisplayObject*)target 
             onDragStart:(BTDragStartBlock)onDragStart 
               onDragged:(BTDraggedBlock)onDragged 
               onDragEnd:(BTDraggedBlock)onDragEnd {
    BTCallbackDragger* dragger = [[BTCallbackDragger alloc] init];
    dragger.onDragStart = onDragStart;
    dragger.onDragged = onDragged;
    dragger.onDragEnd = onDragEnd;
    return dragger;
}

- (id)initWithTarget:(BTDisplayObject*)target enabled:(BOOL)enabled {
    if (!(self = [super init])) {
        return nil;
    }
    _target = target;
    self.enabled = enabled;
    return self;
}

- (id)initWithTarget:(BTDisplayObject*)target {
    return [self initWithTarget:target enabled:YES];
}

- (void)cleanup {
    [super cleanup];
}

- (BOOL)enabled {
    return _touchBeganConn != nil;
}

- (BOOL)dragging {
    return _draggerReg != nil;
}

- (void)setEnabled:(BOOL)enabled {
    if (self.enabled == enabled) {
        return;
    }
    
    if (enabled) {
        _touchBeganConn = [self.conns onObjectReactor:_target.touchBegan connectSlot:^(SPTouch* touch) {
            _draggerReg = [self.mode.input registerListener:self];
            _start = [SPPoint pointWithX:touch.globalX y:touch.globalY];
            [self onDragStart:_start];
        }];
        
    } else {
        [_touchBeganConn disconnect];
        _touchBeganConn = nil;
        [self cancelDrag];
    }
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

@implementation BTCallbackDragger

@synthesize onDragStart, onDragged, onDragEnd;

- (void)onDragStart:(SPPoint*)start {
    if (onDragStart != nil) {
        onDragStart(start);
    }
}

- (void)onDragged:(SPPoint*)current start:(SPPoint*)start {
    if (onDragged != nil) {
        onDragged(current, start);
    }
}

- (void)onDragEnd:(SPPoint*)current start:(SPPoint*)start {
    if (onDragEnd != nil) {
        onDragEnd(current, start);
    }
}

@end