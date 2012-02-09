//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTMode+Protected.h"

@class RAUnitSignal;

@interface BTLoadingMode : BTMode {
@protected
    NSMutableArray* _filenames;
    int _filenameIdx;
}

@property (nonatomic,readonly) RAUnitSignal* loadComplete;

- (id)init;
- (void)addFiles:(NSString*)filename, ... NS_REQUIRES_NIL_TERMINATION;

@end

@interface BTLoadingMode (protected)
- (void)enter;
@end
