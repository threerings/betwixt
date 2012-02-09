//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTObject.h"

@interface BTDisplayObject : BTObject

@property(nonatomic,readonly) SPDisplayObject* display; // abstract

+ (BTDisplayObject*)create:(SPDisplayObject*)disp;

@end
