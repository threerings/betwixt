//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTInput.h"

typedef void (^BTDragStartBlock)(SPPoint* start);
typedef void (^BTDraggedBlock)(SPPoint* current, SPPoint* start);

@interface BTDragger : NSObject <BTTouchListener> {
@protected
    SPPoint* _start;
    SPPoint* _current;
}

- (void)onDragStart:(SPPoint*)start;
- (void)onDragged:(SPPoint*)current start:(SPPoint*)start;
- (void)onDragEnd:(SPPoint*)current start:(SPPoint*)start;

+ (BTDragger*)onDragStart:(BTDragStartBlock)onDragStart onDragged:(BTDraggedBlock)onDragged 
                 onDragEnd:(BTDraggedBlock)onDragEnd;

@end
