//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTInput.h"

@interface BTInput (package)
- (id)initWithMode:(BTMode*)mode;
- (void)processTouches:(NSSet*)touches;
@end