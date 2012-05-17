//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTNode.h"

@interface BTSignalTask : BTNode {
@protected
    __weak RAReactor* _sig;
}

/// Completes when the given signal is fired
+ (BTSignalTask*)waitForSignal:(RAReactor*)signal;

@end
