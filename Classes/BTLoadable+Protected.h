//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTLoadable.h"

@interface BTLoadable (protected)
/**
 * Subclasses should implement loading logic here, and call loadSuccess or loadError when loading
 * has finished.
 */
- (void)doLoad;
- (void)loadSuccess;
- (void)loadError:(NSException*)err;
@end