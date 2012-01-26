//
//  Betwixt - Copyright 2012 Three Rings Design

#import "BTLoadingMode.h"
#import "BTMode+Protected.h"
#import "BTApp.h"
#import "BTResourceManager.h"

@implementation BTLoadingMode

- (id)init {
    if (!(self = [super init])) {
        return nil;
    }
    _filenames = [NSMutableArray array];
    _filenameIdx = -1;
    return self;
}

- (BTLoadingMode *)add:(NSString *)filename {
    [_filenames addObject:filename];
    return self;
}

- (BOOL)loadComplete {
    return (_filenameIdx >= _filenames.count);
}

@end

@implementation BTLoadingMode (protected)

- (void)onError:(NSException *)err {
    NSLog(@"LoadingMode error: %@", err);
}

- (void)loadNextFile {
    if (++_filenameIdx >= _filenames.count) {
        return; // we're done.
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

@end
