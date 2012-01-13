//
// gulp - Copyright 2011 Three Rings Design

#import "GULoadable.h"
#import "GULoadable+Protected.h"

@interface Callback : NSObject
@end

@implementation Callback {
    GUCompleteCallback _onComplete;
    GUErrorCallback _onError;
}

- (id)init:(GUCompleteCallback)onComplete onError:(GUErrorCallback)onError
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

@implementation GULoadable

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

- (void)load:(GUCompleteCallback)onComplete
{
    [self load:onComplete onError:nil];
}

-(void)load:(GUCompleteCallback)onComplete onError:(GUErrorCallback)onError
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
    GULoadableState state = (error == nil ? LS_LOADED : LS_ERROR);
    
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
        NSLog(@"Unhandled exception in GULoadable.loadComplete: %@", exception);
    }
}

- (void)loadSuccess {
    [self loadComplete:nil];
}

- (void)loadError:(NSException *)err {
    [self loadComplete:err];
}

@end
