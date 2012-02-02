//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTNode.h"

@interface BTNode (protected)
/// Called when the node is destroyed - either by being detached during normal gameplay,
/// or when its BTMode is shut down. Subclasses that manage resources should release
/// them in this function. No gameplay code should be run in cleanup.
- (void)cleanup;
@end
