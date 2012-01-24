//
//  gulp - Copyright 2011 Three Rings Design

#import "BTLoadableBatch.h"

@interface BTLoadableBatch ()
- (void)load1Loadable:(BTLoadable *)loadable;
- (void)loadableLoaded:(BTLoadable *)loadable withError:(NSException *)err;
@end;

@implementation BTLoadableBatch

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }

    _allLoadables = [[NSMutableArray alloc] init];
    _loadedLoadables = [[NSMutableArray alloc] init];

    return self;
}

- (void)add:(BTLoadable *)loadable
{
    NSAssert(self.state == LS_NOT_LOADED, @"Can't add BTLoadables now [state=%d]", self.state);
    [_allLoadables addObject:loadable];
}

- (void)doLoad
{
    @synchronized(self) {
        if ([_allLoadables count] == 0) {
            // don't have anything to load
            [self loadSuccess];
            return;
        }

        for (BTLoadable *loadable in _allLoadables) {
            [self load1Loadable:loadable];
            // don't continue if the load operation has been canceled/errored,
            // or if we're loading in sequence
            if (self.state != LS_LOADING || _loadInSequence) {
                break;
            }
        }
    }
}

- (void)load1Loadable:(BTLoadable *)loadable
{
    __weak BTLoadableBatch* this = self;
    [loadable load: ^{ [this loadableLoaded:loadable withError:nil]; }
           onError:^(NSException* err) { [this loadableLoaded:loadable withError:err]; }];
}

- (void)loadableLoaded:(BTLoadable *)loadable withError:(NSException *)err
{
    // We may have already errored out, in which case, ignore
    @synchronized(self) {
        if (self.state == LS_ERROR) {
            return;
        }

        if (err != nil) {
            [self loadError:err];
        } else {
            [_loadedLoadables addObject:loadable];
            if ([_loadedLoadables count] == [_allLoadables count]) {
                // We finished loading
                [self loadSuccess];
            } else if (_loadInSequence) {
                // We have more to load
                [self load1Loadable:[_allLoadables objectAtIndex:[_loadedLoadables count]]];
            }
        }
    }
}

@end
