//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTNode.h"

@interface BTNode (protected)

/// Called when the node is added to the node tree. Subclasses will generally want to
/// perform most of their setup code in attached, rather than in their init function, since
/// it's an error to attach other nodes before this point.
- (void)added;

/// Called when the node is destroyed - either by being removed during normal gameplay,
/// or when its BTMode is shut down. Subclasses that manage resources should release
/// them in this function. No gameplay code should be run in cleanup.
- (void)cleanup;

@end

