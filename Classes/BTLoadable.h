//
//  Betwixt - Copyright 2011 Three Rings Design

typedef enum {
    LS_NOT_LOADED,
    LS_LOADING,
    LS_LOADED,
    LS_ERROR
} GULoadableState;

typedef void (^BTCompleteCallback)(void);
typedef void (^BTErrorCallback)(NSException *);

@interface BTLoadable : NSObject {
@protected
    GULoadableState _state;
    NSException* _loadError;
    NSMutableArray* _callbacks;
}

@property(readonly) GULoadableState state;
- (id)init;
- (void)load:(BTCompleteCallback)onComplete;
- (void)load:(BTCompleteCallback)onComplete onError:(BTErrorCallback)onError;
@end
