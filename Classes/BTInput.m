//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTInput.h"
#import "BTMode.h"
#import "SPTouchProcessor.h"
#import "SPTouch_Internal.h"
#import "SPPoint+Extensions.h"

@class BTReaction;

@interface BTInputRegistration ()
- (id)initWithInput:(BTInput*)input listener:(id<BTTouchListener>)l;
@end

@implementation BTInput

- (id)initWithMode:(BTMode*)mode {
    if (!(self = [super init])) {
        return nil;
    }
    _touchProcessor = [[SPTouchProcessor alloc] initWithRoot:mode.sprite];
    _listeners = [NSMutableArray array];
    return self;
}

- (BTInputRegistration*)registerListener:(id<BTTouchListener>)l {
    [_listeners addObject:l];
    return [[BTInputRegistration alloc] initWithInput:self listener:l];
}

- (void)removeAllListeners {
    [_listeners removeAllObjects];
}

- (void)removeListener:(id<BTTouchListener>)l {
    [_listeners removeObject:l];
}

- (void)processTouches:(NSSet*)touches {
    // we currently only process one touch
    // process new touches
    SPTouch* currentTouch = nil;
    
    if (_lastTouch != nil) {
        for (SPTouch* touch in touches) {
            if ((_lastTouch.globalX == touch.previousGlobalX &&
                 _lastTouch.globalY == touch.previousGlobalY) ||
                (_lastTouch.globalX == touch.globalX &&
                 _lastTouch.globalY == touch.globalY)) {
             
                // existing touch; update values
                _lastTouch.timestamp = touch.timestamp;
                _lastTouch.previousGlobalX = touch.previousGlobalX;
                _lastTouch.previousGlobalY = touch.previousGlobalY;
                _lastTouch.globalX = touch.globalX;
                _lastTouch.globalY = touch.globalY;
                _lastTouch.phase = touch.phase;
                _lastTouch.tapCount = touch.tapCount;
                    
                currentTouch = _lastTouch;
                break;
            }  
        }
    }
    
    if (currentTouch == nil) {
        // find a new touch
        for (SPTouch* touch in touches) {
            if (touch.phase == SPTouchPhaseBegan) {
                // new touch!
                currentTouch = [SPTouch touch];
                currentTouch.timestamp = touch.timestamp;
                currentTouch.globalX = touch.globalX;
                currentTouch.globalY = touch.globalY;
                currentTouch.previousGlobalX = touch.previousGlobalX;
                currentTouch.previousGlobalY = touch.previousGlobalY;
                currentTouch.phase = touch.phase;
                currentTouch.tapCount = touch.tapCount;
                
                break;
            }
        }
    }
    
    // Send the touch to our listeners - they can interrupt any input
    BOOL handled = NO;
    if (currentTouch != nil && currentTouch.phase != SPTouchPhaseStationary && _listeners.count > 0) {
        NSArray* listeners = [NSArray arrayWithArray:_listeners];
        SPPoint* touchPt = [SPPoint pointWithX:currentTouch.globalX y:currentTouch.globalY];
        for (id<BTTouchListener> l in listeners) {
            switch (currentTouch.phase) {
            case SPTouchPhaseBegan:
                handled = [l onTouchStart:touchPt];
                break;
            
            case SPTouchPhaseMoved:
                handled = [l onTouchMove:touchPt];
                break;
                
            case SPTouchPhaseEnded:
            case SPTouchPhaseCancelled:
                handled = [l onTouchEnd:touchPt];
                break;
                    
            case SPTouchPhaseStationary:
                handled = NO;
                break;
            }
            
            if (handled) {
                break;
            }
        }
    }
    
    _lastTouch = currentTouch;
    
    // If it wasn't handled by any listeners, let the touch processor do its thing
    if (!handled) {
        [_touchProcessor processTouches:touches];
    }
}

@end

@implementation BTInputRegistration {
@protected
    __weak BTInput* _input;
    __weak id<BTTouchListener> _listener;
}
- (id)initWithInput:(BTInput*)input listener:(id<BTTouchListener>)l {
    if (!(self = [super init])) {
        return nil;
    }
    _input = input;
    _listener = l;
    return self;
}
- (void)cancel {
    [_input removeListener:_listener];
    _input = nil;
    _listener = nil;
}
@end
