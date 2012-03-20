//
// Betwixt - Copyright 2012 Three Rings Design

@class BTMode;
@class SPTouchProcessor;
@class BTInput;

@interface BTInputRegistration : NSObject
- (void)cancel;
@end

@protocol BTTouchListener
- (void)onTouchStart:(SPPoint*)globalPt;
- (void)onTouchMove:(SPPoint*)globalPt;
- (void)onTouchEnd:(SPPoint*)globalPt;
@end

@protocol BTInputRegion
/// Returns true if this region can be triggered, false if it's currently inactive.
- (BOOL)canTrigger;
/// Returns true if this region is no longer relevant and should be removed.
- (BOOL)hasExpired;
/// Returns true if the (screen-coordinates) point triggers falls in this region.
- (BOOL)hitTest:(SPPoint*)globalPt;
@end

typedef void (^BTTouchBlock)(SPPoint* p);

@interface BTInputRegionImpl : NSObject <BTInputRegion> {
@protected
    __weak BTInput* _input;
}
- (id)initWithInput:(BTInput*)input;

- (BTInputRegistration*)registerListener:(id<BTTouchListener>)l;

- (BTInputRegistration*)onTouchStart:(BTTouchBlock)onTouchStart 
                        onTouchMove:(BTTouchBlock)onTouchMove
                         onTouchEnd:(BTTouchBlock)onTouchEnd;
- (BTInputRegistration*)onTouchStart:(BTTouchBlock)onTouchStart
                         onTouchEnd:(BTTouchBlock)onTouchEnd;
- (BTInputRegistration*)onTouchStart:(BTTouchBlock)onTouchStart;
- (BTInputRegistration*)onTouchEnd:(BTTouchBlock)onTouchEnd;
@end

/// A Region that triggers on any touch
@interface BTScreenRegion : BTInputRegionImpl
+ (BTScreenRegion*)withInput:(BTInput*)input;
@end

/// A Region that triggers on touches that intersect a given rectangle
@interface BTBoundsRegion : BTInputRegionImpl
+ (BTBoundsRegion*)withInput:(BTInput*)input bounds:(SPRectangle*)bounds;
- (id)initWithInput:(BTInput*)input bounds:(SPRectangle*)bounds;
@end

/// A Region that triggers on touches that intersect a SPDisplayObject
@interface BTDisplayObjectRegion : BTInputRegionImpl
+ (BTDisplayObjectRegion*)withInput:(BTInput*)input disp:(SPDisplayObject*)disp;
- (id)initWithInput:(BTInput*)input displayObject:(SPDisplayObject*)disp;
@end

@interface BTInput : NSObject {
    SPTouchProcessor* _touchProcessor;
    NSMutableArray* _reactions;
    id<BTTouchListener> _activeListener;
    SPTouch* _lastTouch;
}

- (BTInputRegistration*)registerListener:(id<BTTouchListener>)listener forRegion:(id<BTInputRegion>)region;
- (void)removeAllListeners;

@end
