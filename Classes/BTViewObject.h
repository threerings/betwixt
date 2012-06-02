//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTObject.h"
#import "BTTouchable.h"

/// A BTObject that wraps an SPDisplayObject
@interface BTViewObject : BTObject <BTTouchable>

@property (nonatomic,readonly) SPDisplayObject* display; // abstract

+ (BTViewObject*)viewObjectWithDisplay:(SPDisplayObject*)disp;

@end
