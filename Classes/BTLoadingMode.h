//
//  Betwixt - Copyright 2012 Three Rings Design

#import "BTMode+Protected.h"

@interface BTLoadingMode : BTMode {
@protected
    NSMutableArray *_filenames;
    int _filenameIdx;
}

@property (readonly) BOOL loadComplete;

- (id)init;
- (BTLoadingMode *)add:(NSString *)filename;

@end

@interface BTLoadingMode (protected)
- (void)enter;
@end
