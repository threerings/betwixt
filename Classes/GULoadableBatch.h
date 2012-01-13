//
//  gulp - Copyright 2011 Three Rings Design

#import "GULoadable+Protected.h"

@interface GULoadableBatch : GULoadable {
@protected
    BOOL _loadInSequence;
    NSMutableArray* _allLoadables;
    NSMutableArray* _loadedLoadables;
}

- (id)init;
- (void)add:(GULoadable*)loadable;

@end
