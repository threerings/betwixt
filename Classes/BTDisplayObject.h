//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTObject.h"
#import "BTHasLocation.h"

@interface BTDisplayObject : BTObject<BTHasLocation>

@property(nonatomic,readonly) SPDisplayObject *display; // abstract
@property(nonatomic,assign) float x;
@property(nonatomic,assign) float y;

@end
