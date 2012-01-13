//
//  gulp - Copyright 2011 Three Rings Design

#import "BTLoadable+Protected.h"

@interface BTLoadableBatch : BTLoadable {
@protected
    BOOL _loadInSequence;
    NSMutableArray* _allLoadables;
    NSMutableArray* _loadedLoadables;
}

- (id)init;
- (void)add:(BTLoadable*)loadable;

@end
