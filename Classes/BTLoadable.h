//
//  Betwixt - Copyright 2011 Three Rings Design

typedef enum {
    LS_NOT_LOADED,
    LS_LOADING,
    LS_LOADED,
    LS_ERROR
} BTLoadableState;

typedef void (^BTCompleteCallback)(void);
typedef void (^BTErrorCallback)(NSException *);

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
