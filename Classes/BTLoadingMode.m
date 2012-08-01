//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTLoadingMode.h"
#import "RAUnitSignal.h"
#import "BTMode+Protected.h"
#import "BTApp.h"
#import "BTResourceManager.h"

@interface BTLoadingMode ()
- (void)loadNow;
- (void)onError:(NSException*)err;
@end

@implementation BTLoadingMode

@synthesize loadComplete = _loadComplete;

- (id)init {
    if ((self = [super init])) {
        _loadComplete = [[RAUnitSignal alloc] init];
        _filenames = [NSMutableArray array];

        [_conns onReactor:self.entered connectUnit:^{
            [self loadNow];
        }];
    }
    return self;
}

- (void)addFiles:(NSString*)filename, ... {
    [_filenames addObjectsFromArray:OOO_VARARGS_TO_ARRAY(NSString*, filename)];
}

- (void)addFilesFromArray:(NSArray*)filenames {
    [_filenames addObjectsFromArray:filenames];
}

- (void)loadNow {
    __weak BTLoadingMode* this = self;
    [BTApp.resourceManager loadResourceFiles:_filenames onComplete:^{
        [this.loadComplete emit];
    } onError:^(NSException* err) {
        [this onError:err];
    }];
}

- (void)onError:(NSException*)err {
    NSLog(@"LoadingMode error: %@", err);
}

@end
