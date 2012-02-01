//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTLoadingMode.h"
#import "RAUnitSignal.h"
#import "BTMode+Protected.h"
#import "BTApp.h"
#import "BTResourceManager.h"

@interface BTLoadingMode ()
- (void)loadNextFile;
@end

@implementation BTLoadingMode {
    RAUnitSignal *_loadComplete;
}

- (id)init {
    if (!(self = [super init])) return nil;
    _loadComplete = [[RAUnitSignal alloc] init];
    _filenames = [NSMutableArray array];
    _filenameIdx = -1;
    
    __weak BTLoadingMode* this = self;
    [self.entered connectUnit:^{
        if (_filenameIdx >= 0) {
            // We're already loading
            return;
        }
        [this loadNextFile];
    }];
    
    return self;
}

- (void)addFiles:(NSString *)filename, ... {
    
    [_filenames addObject:filename];
    va_list args;
    va_start(args, filename);
    while ((filename = va_arg(args, NSString *)) != nil) {
        [_filenames addObject:filename];
    }
    va_end(args);
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

@synthesize loadComplete=_loadComplete;

@end
