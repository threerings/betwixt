//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTCallbacks.h"

typedef enum {
    LS_NOT_LOADED,
    LS_LOADING,
    LS_LOADED,
    LS_ERROR
} BTLoadableState;

@interface BTLoadable : NSObject {
@protected
    BTLoadableState _state;
    NSException* _loadError;
    NSMutableArray* _callbacks;
}

@property(readonly) BTLoadableState state;
- (id)init;
- (void)load:(BTCompleteCallback)onComplete;
- (void)load:(BTCompleteCallback)onComplete onError:(BTErrorCallback)onError;
@end
