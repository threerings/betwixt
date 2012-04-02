//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTObject.h"

@class BTEventSignal;

@interface BTDisplayObject : BTObject

@property(nonatomic,readonly) SPDisplayObject* display; // abstract
@property(nonatomic,readonly) BTEventSignal* touched; // <SPTouchEvent*>

+ (BTDisplayObject*)create:(SPDisplayObject*)disp;

@end
