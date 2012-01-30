//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTLoadable.h"
#import "BTLoadable+Protected.h"

@interface Callback : NSObject
@end

@implementation Callback {
    BTCompleteCallback _onComplete;
    BTErrorCallback _onError;
}

- (id)init:(BTCompleteCallback)onComplete onError:(BTErrorCallback)onError
{
    if (!(self = [super init])) {
        return nil;
    }
    _onComplete = onComplete;
    _onError = onError;
    return self;
}

- (void)onComplete
{
    _onComplete();
}

- (void)onError:(NSException *)err
{
    if (_onError != nil) {
        _onError(err);
    }
}

@end

@implementation BTLoadable

@synthesize state=_state;

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }
    _state = LS_NOT_LOADED;
    _callbacks = [[NSMutableArray alloc] init];

    return self;
}

- (void)load:(BTCompleteCallback)onComplete
{
    [self load:onComplete onError:nil];
}

-(void)load:(BTCompleteCallback)onComplete onError:(BTErrorCallback)onError
{
    @synchronized(self) {
        if (_state == LS_LOADED) {
            onComplete();
            return;
        } else if (_state == LS_ERROR) {
            onError(_loadError);
            return;
        }

        [_callbacks addObject:[[Callback alloc] init:onComplete onError:onError]];
        if (_state == LS_NOT_LOADED) {
            // load now!
            _state = LS_LOADING;
            [self doLoad];
        }
    }
}

- (void)doLoad
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void)loadComplete:(NSException *)error
{
    NSMutableArray* callbacks = _callbacks;
    BTLoadableState state = (error == nil ? LS_LOADED : LS_ERROR);

    @synchronized(self) {
        NSAssert(_state == LS_LOADING, @"We weren't loading [state=%d]", _state);
        _loadError = error;
        _state = state;
        _callbacks = [[NSMutableArray alloc] init];
    }

    @try {
        for (Callback* cb in callbacks) {
            if (state == LS_ERROR) {
                [cb onError:error];
            } else {
                [cb onComplete];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Unhandled exception in BTLoadable.loadComplete: %@", exception);
    }
}

- (void)loadSuccess {
    [self loadComplete:nil];
}

- (void)loadError:(NSException *)err {
    [self loadComplete:err];
}

@end
