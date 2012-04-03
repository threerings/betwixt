//
// Betwixt - Copyright 2012 Three Rings Design

@class BTMode;
@class SPTouchProcessor;

@interface BTInputRegistration : NSObject
- (void)cancel;
@end

@protocol BTTouchListener
- (BOOL)onTouchStart:(SPPoint*)globalPt;
- (BOOL)onTouchMove:(SPPoint*)globalPt;
- (BOOL)onTouchEnd:(SPPoint*)globalPt;
@end

@interface BTInput : NSObject {
    SPTouchProcessor* _touchProcessor;
    NSMutableArray* _listeners;
    SPTouch* _lastTouch;
}

- (BTInputRegistration*)registerListener:(id<BTTouchListener>)l;
- (void)removeAllListeners;

@end
