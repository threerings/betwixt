//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMode+Protected.h"

@class RAUnitSignal;

@interface BTLoadingMode : BTMode {
@protected
    RAUnitSignal* _loadComplete;
    NSMutableArray* _filenames;
}

@property (nonatomic,readonly) RAUnitSignal* loadComplete;

- (id)init;
- (void)addFiles:(NSArray*)filenames;

@end

@interface BTLoadingMode (protected)
- (void)enter;
@end
