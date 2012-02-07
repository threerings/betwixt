//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTInput.h"

@interface BTDragger : NSObject <BTTouchListener> {
@protected
    SPPoint *_start;
    SPPoint *_current;
}

- (void)onDragStart:(SPPoint *)start;
- (void)onDragged:(SPPoint *)current start:(SPPoint *)start;
- (void)onDragEnd:(SPPoint *)current start:(SPPoint *)start;

@end
