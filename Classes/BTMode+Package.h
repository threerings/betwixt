//
// Betwixt - Copyright 2012 Three Rings Design

@interface BTMode (package)

- (void)addKeys:(BTNode*)object;
- (void)addGroups:(BTNode*)object;
- (void)setupInternal;
- (void)shutdownInternal;
- (void)enterInternal;
- (void)exitInternal;

@end
