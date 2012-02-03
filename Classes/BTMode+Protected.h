//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMode.h"

@interface BTMode (protected)
- (void)setup;
- (void)destroy;
- (void)update:(float)dt;
- (void)processTouches:(NSSet *)touches;
@end