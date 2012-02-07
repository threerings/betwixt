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

/// A Region that triggers on any touch
@interface BTScreenRegion : BTInputRegion
@end

/// A Region that triggers on touches that intersect a given rectangle
@interface BTBoundsRegion : BTInputRegion
- (id)initWithBounds:(SPRectangle *)bounds;
@end

/// A Region that triggers on touches that intersect a SPDisplayObject
@interface BTDisplayObjectRegion : BTInputRegion
- (id)initWithDisplayObject:(SPDisplayObject *)disp;
@end


@protocol BTTouchListener
- (void)onTouchStart:(SPPoint *)globalPt;
- (void)onTouchMove:(SPPoint *)globalPt;
- (void)onTouchEnd:(SPPoint *)globalPt;
@end

@interface BTInput : NSObject {
    SPTouchProcessor *_touchProcessor;
    NSMutableArray *_reactions;
    id<BTTouchListener> _activeListener;
    SPTouch *_lastTouch;
}

- (BTInputRegistration *)registerListener:(id<BTTouchListener>)listener forRegion:(BTInputRegion *)region;

- (BTInputRegistration *)registerScreenListener:(id<BTTouchListener>)listener;
- (BTInputRegistration *)registerListener:(id<BTTouchListener>)listener forBounds:(SPRectangle *)bounds;
- (BTInputRegistration *)registerListener:(id<BTTouchListener>)listener forDisplayObject:(SPDisplayObject *)disp;

@end
