//
// gulp - Copyright 2011 Three Rings Design

typedef enum {
    LS_NOT_LOADED,
    LS_LOADING,
    LS_LOADED,
    LS_ERROR
} GULoadableState;

typedef void (^GUCompleteCallback)(void);
typedef void (^GUErrorCallback)(NSException *);

@interface GULoadable : NSObject {
@protected
    GULoadableState _state;
    NSException* _loadError;
    NSMutableArray* _callbacks;
}

@property(readonly) GULoadableState state;
- (id)init;
- (void)load:(GUCompleteCallback)onComplete;
- (void)load:(GUCompleteCallback)onComplete onError:(GUErrorCallback)onError;
@end
