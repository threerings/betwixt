//
// Betwixt - Copyright 2012 Three Rings Design

@class BTMode;
@class SPTouchProcessor;

@interface BTInputRegistration : NSObject
- (void)cancel;
@end

@interface BTInputRegion : NSObject
/// Returns true if this region can be triggered, false if it's currently invisible.
- (BOOL)canTrigger;
/// Returns true if this region is no longer relevant and should be removed.
- (BOOL)hasExpired;
/// Returns true if the (screen-coordinates) point triggers falls in this region.
- (BOOL)hitTest:(SPPoint *)globalPt;
@end

@interface BTTouchListener : NSObject
- (void)onTouchStart:(SPPoint *)globalPt;
- (void)onTouchMove:(SPPoint *)globalPt;
- (void)onTouchEnd:(SPPoint *)globalPt;
@end

@interface BTInput : NSObject {
    SPTouchProcessor *_touchProcessor;
    NSMutableArray *_reactions;
    BTTouchListener *_activeListener;
    SPTouch *_lastTouch;
}

- (id)initWithMode:(BTMode *)mode;
- (void)processTouches:(NSSet *)touches;

- (BTInputRegistration *)registerListener:(BTTouchListener *)listener forRegion:(BTInputRegion *)region;

- (BTInputRegistration *)registerScreenListener:(BTTouchListener *)listener;
- (BTInputRegistration *)registerListener:(BTTouchListener *)listener forBounds:(SPRectangle *)bounds;
- (BTInputRegistration *)registerListener:(BTTouchListener *)listener forDisplayObject:(SPDisplayObject *)disp;

@end
