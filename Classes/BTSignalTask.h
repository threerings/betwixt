//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTNode.h"

@interface BTSignalTask : BTNode

/// Completes when the given signal is fired
+ (BTSignalTask*)waitForSignal:(RAReactor*)signal;

@end
