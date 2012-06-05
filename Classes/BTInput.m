//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTInput.h"
#import "BTMode.h"
#import "SPTouchProcessor.h"
#import "SPTouch_Internal.h"
#import "SPPoint+BTExtensions.h"

@class BTReaction;

@implementation BTInput

- (id)initWithRoot:(SPDisplayObjectContainer*)root {
    if ((self = [super init])) {
        _root = root;
        _listeners = [NSMutableArray array];
        _currentTouches = [[NSMutableSet alloc] initWithCapacity:2];
    }
    return self;
}

- (id<OOORegistration>)registerListener:(id<BTTouchListener>)l {
    [_listeners addObject:l];
    
    __weak BTInput* this = self;
    __weak id<BTTouchListener> weakListener = l;
    return [OOORegistrationFactory withBlock:^{
        if (this && weakListener) {
            [this->_listeners removeObject:weakListener];
        }
    }];
}

- (void)removeAllListeners {
    [_listeners removeAllObjects];
}

- (void)processTouches:(NSSet*)touches {   
    NSMutableSet *processedTouches = [[NSMutableSet alloc] init];
    
    // process new touches
    for (SPTouch *touch in touches) {
        SPTouch *currentTouch = nil;
        
        for (SPTouch *existingTouch in _currentTouches) {
            if (existingTouch.phase == SPTouchPhaseEnded || existingTouch.phase == SPTouchPhaseCancelled) {
                continue;
            }
            
            if ((existingTouch.globalX == touch.previousGlobalX &&
                 existingTouch.globalY == touch.previousGlobalY) ||
                (existingTouch.globalX == touch.globalX &&
                 existingTouch.globalY == touch.globalY)) {
                // existing touch; update values
                existingTouch.timestamp = touch.timestamp;
                existingTouch.previousGlobalX = touch.previousGlobalX;
                existingTouch.previousGlobalY = touch.previousGlobalY;
                existingTouch.globalX = touch.globalX;
                existingTouch.globalY = touch.globalY;
                existingTouch.phase = touch.phase;
                existingTouch.tapCount = touch.tapCount;
                
                if (!existingTouch.target.stage) {
                    // target could have been removed from stage -> find new target in that case
                    SPPoint *touchPosition = [SPPoint pointWithX:touch.globalX y:touch.globalY];
                    existingTouch.target = [_root hitTestPoint:touchPosition forTouch:YES];       
                }
                
                currentTouch = existingTouch;
                break;
            }
        }
        
        if (!currentTouch) {
            // new touch!
            currentTouch = [SPTouch touch];
            currentTouch.timestamp = touch.timestamp;
            currentTouch.globalX = touch.globalX;
            currentTouch.globalY = touch.globalY;
            currentTouch.previousGlobalX = touch.previousGlobalX;
            currentTouch.previousGlobalY = touch.previousGlobalY;
            currentTouch.phase = touch.phase;
            currentTouch.tapCount = touch.tapCount;
            SPPoint *touchPosition = [SPPoint pointWithX:touch.globalX y:touch.globalY];
            currentTouch.target = [_root hitTestPoint:touchPosition forTouch:YES];
        }
        
        [processedTouches addObject:currentTouch];
    }
    
    // For each touch, first send it to our listeners who get first chance at all input.
    // If a listener doesn't handle the touch, dispatch it to the display list.
    for (SPTouch *touch in processedTouches) {
        // touch listeners don't handle SPTouchPhaseStationary. We throw those away.
        BOOL handled = (_listeners.count > 0 && touch.phase == SPTouchPhaseStationary);
        if (!handled && _listeners.count > 0) {
            NSArray* listeners = [NSArray arrayWithArray:_listeners];
            for (id<BTTouchListener> l in listeners.reverseObjectEnumerator) {
                switch (touch.phase) {
                    case SPTouchPhaseBegan:
                        handled = [l onTouchStart:touch];
                        break;
                        
                    case SPTouchPhaseMoved:
                        handled = [l onTouchMove:touch];
                        break;
                        
                    case SPTouchPhaseEnded:
                    case SPTouchPhaseCancelled:
                        handled = [l onTouchEnd:touch];
                        break;
                        
                    // avoid warning for not handling all cases.
                    case SPTouchPhaseStationary:
                        handled = YES;
                        break;
                }
                
                if (handled) {
                    break;
                }
            }
        }
        
        if (!handled) {
            SPTouchEvent *touchEvent = [[SPTouchEvent alloc] initWithType:SP_EVENT_TYPE_TOUCH 
                                                                  touches:processedTouches];
            [touch.target dispatchEvent:touchEvent];
        }
    }
    
    _currentTouches = processedTouches;    
}

@end