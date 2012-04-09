//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTHasLocation.h"
#import "SPDisplayObject.h"

@interface SPDisplayObject (OOOExtensions) <BTHasLocation>

/// The coordinates of the object relative to the local coordinates of the parent
@property (nonatomic,copy) SPPoint* loc;

/// The screen location of this DisplayObject
@property (nonatomic,copy) SPPoint* globalLoc;

/// The object's origin in its own coordinate space
@property (nonatomic,copy) SPPoint* pivot;

/// The object's x and y scale factor
@property (nonatomic,copy) SPPoint* scale;

@end
