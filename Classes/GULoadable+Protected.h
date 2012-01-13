//
// gulp - Copyright 2011 Three Rings Design

#import "GULoadable.h"

@interface GULoadable (protected)
/**
 * Subclasses should implement loading logic here, and call loadSuccess or loadError when loading
 * has finished.
 */
- (void)doLoad;
- (void)loadSuccess;
- (void)loadError:(NSException *)err;
@end