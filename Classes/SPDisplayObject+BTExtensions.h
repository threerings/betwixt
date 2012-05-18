//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTHasLocation.h"
#import "SPDisplayObject.h"

typedef BOOL (^BTTraverseCallback)(SPDisplayObject* disp);

@interface SPDisplayObject (BTExtensions) <BTHasLocation>

/// The coordinates of the object relative to the local coordinates of the parent
@property (nonatomic,copy) SPPoint* loc;

/// The screen location of this DisplayObject
@property (nonatomic,copy) SPPoint* globalLoc;

/// The object's origin in its own coordinate space
@property (nonatomic,copy) SPPoint* pivot;

/// The object's x and y scale factor
@property (nonatomic,copy) SPPoint* scale;

+ (SPPoint*)transformPoint:(SPPoint*)pt from:(SPDisplayObject*)from to:(SPDisplayObject*)to;

/// Traverses the display list from frontmost to rearmost SPDisplayObject.
/// 'callback' is called for each display object (including this one).
/// if callback returns NO, the traversal is stopped. 
- (void)traverse:(BTTraverseCallback)callback;

/// Traverses the display list from frontmost to rearmost SPDisplayObject.
/// 'callback' is called for each display object (including this one).
/// if callback returns NO, the traversal is stopped.
/// Before branches are traversed, 'filter' is called. If filter returns NO, the branch
/// rooted at the given display object won't be traversed. (This is useful to, e.g., prune
/// invisible display objects from the traversal.)
- (void)traverseWithFilter:(BTTraverseCallback)filter callback:(BTTraverseCallback)callback;

@end
