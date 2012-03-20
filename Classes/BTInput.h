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

/// A Region that triggers on any touch
@interface BTScreenRegion : NSObject <BTInputRegion>
@end

/// A Region that triggers on touches that intersect a given rectangle
@interface BTBoundsRegion : NSObject <BTInputRegion>
- (id)initWithBounds:(SPRectangle*)bounds;
@end

/// A Region that triggers on touches that intersect a SPDisplayObject
@interface BTDisplayObjectRegion : NSObject <BTInputRegion>
- (id)initWithDisplayObject:(SPDisplayObject*)disp;
- (id)initWithDisplayObject:(SPDisplayObject*)disp bounds:(SPRectangle*)bounds;
@end

typedef void (^BTTouchBlock)(SPPoint* p);

@interface BTInputRegistrar : NSObject

- (BTInputRegistration*)listener:(id<BTTouchListener>)l;

- (BTInputRegistration*)onTouchStart:(BTTouchBlock)onTouchStart 
                         onTouchMove:(BTTouchBlock)onTouchMove
                          onTouchEnd:(BTTouchBlock)onTouchEnd;
- (BTInputRegistration*)onTouchStart:(BTTouchBlock)onTouchStart
                          onTouchEnd:(BTTouchBlock)onTouchEnd;
- (BTInputRegistration*)onTouchStart:(BTTouchBlock)onTouchStart;
- (BTInputRegistration*)onTouchEnd:(BTTouchBlock)onTouchEnd;

- (id)initWithInput:(BTInput*)input region:(id<BTInputRegion>)region;
@end

@interface BTInput : NSObject {
    SPTouchProcessor* _touchProcessor;
    NSMutableArray* _reactions;
    id<BTTouchListener> _activeListener;
    SPTouch* _lastTouch;
}

- (BTInputRegistrar*)registerRegion:(id<BTInputRegion>)region;
- (BTInputRegistrar*)registerScreenRegion;
- (BTInputRegistrar*)registerBounds:(SPRectangle*)bounds;
- (BTInputRegistrar*)registerDisplayObject:(SPDisplayObject*)disp;

- (void)removeAllListeners;

@end
