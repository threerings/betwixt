//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTLoadingMode.h"
#import "RAUnitSignal.h"
#import "BTMode+Protected.h"
#import "BTApp.h"
#import "BTResourceManager.h"

@implementation BTLoadingMode {
    RAUnitSignal *_loadComplete;
}

- (id)init {
    if (!(self = [super init])) return nil;
    _loadComplete = [[RAUnitSignal alloc] init];
    _filenames = [NSMutableArray array];
    _filenameIdx = -1;
    return self;
}

- (BTLoadingMode *)add:(NSString *)filename {
    [_filenames addObject:filename];
    return self;
}

- (void)onError:(NSException *)err {
    NSLog(@"LoadingMode error: %@", err);
}

- (void)loadNextFile {
    if (++_filenameIdx >= _filenames.count) {
        [_loadComplete emit];
        return;
    }
    NSString *filename = [_filenames objectAtIndex:_filenameIdx];

    __weak BTLoadingMode *this = self;
    [[BTApp resourceManager] loadResourceFile:filename onComplete:^{
        [this loadNextFile];
    } onError:^(NSException *err) {
        [this onError:err];
    }];
}

- (void)enter {
    [super enter];

    if (_filenameIdx >= 0) {
        // We're already loading
        return;
    }
    [self loadNextFile];
}

@synthesize loadComplete=_loadComplete;

@end
