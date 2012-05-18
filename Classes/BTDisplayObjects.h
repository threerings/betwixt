//
// Betwixt - Copyright 2012 Three Rings Design

typedef BOOL (^BTTraverseCallback)(SPDisplayObject* disp);

/// Utility functions for SPDisplayObjects
@interface BTDisplayObjects : NSObject

+ (SPPoint*)transformPoint:(SPPoint*)pt from:(SPDisplayObject*)from to:(SPDisplayObject*)to;

/// Traverses the display list from frontmost to rearmost SPDisplayObject.
/// 'callback' is called for each display object (including root).
/// if callback returns NO, the traversal is stopped. 
+ (void)traverseDisplayList:(SPDisplayObject*)root callback:(BTTraverseCallback)callback;

/// Traverses the display list from frontmost to rearmost SPDisplayObject.
/// 'callback' is called for each display object (including root).
/// if callback returns NO, the traversal is stopped.
/// Before branches are traversed, 'filter' is called. If filter returns NO, the branch
/// rooted at the given display object won't be traversed. (This is useful to, e.g., prune
/// invisible display objects from the traversal.)
+ (void)traverseDisplayList:(SPDisplayObject*)root withFilter:(BTTraverseCallback)filter 
                   callback:(BTTraverseCallback)callback;


@end
