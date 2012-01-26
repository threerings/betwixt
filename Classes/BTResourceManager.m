//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTResourceManager.h"
#import "BTResourceFactory.h"
#import "BTResource.h"
#import "GDataXMLException.h"

#import "GDataXMLNode+OOO.h"

@interface LoadTask : NSObject {
@public
    NSString *_filename;
    NSArray *_resources;
    NSException *_err;
    BTCompleteCallback _onComplete;
    BTErrorCallback _onError;
}
- (id)initWithFilename:(NSString *)filename onComplete:(BTCompleteCallback)onComplete
               onError:(BTErrorCallback)onError;
- (void)load;

@property (readonly,strong) NSString *filename;
@property (readonly,strong) NSArray *resources;
@property (readonly,strong) NSException *err;
@property (readonly,strong) BTCompleteCallback onComplete;
@property (readonly,strong) BTErrorCallback onError;
@end

@implementation BTResourceManager

+ (BTResourceManager *)sharedManager {
    static BTResourceManager *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[BTResourceManager alloc] init];
        }
    }
    return instance;
}

- (id)init {
    if (!(self = [super init])) {
        return nil;
    }
    _factories = [[NSMutableDictionary alloc] init];
    _resources = [[NSMutableDictionary alloc] init];
    _loadingFiles = [[NSMutableSet alloc] init];
    _loadedFiles = [[NSMutableSet alloc] init];
    return self;
}

- (BOOL)isResourceFileLoaded:(NSString *)filename {
    return [_loadedFiles containsObject:filename] || [_loadingFiles containsObject:filename];
}

- (void)loadResourceFile:(NSString *)filename onComplete:(BTCompleteCallback)onComplete 
                 onError:(BTErrorCallback)onError {
    NSAssert(![self isResourceFileLoaded:filename], 
             @"Resource file '%@' already loaded (or is loading)", filename);
    
    [_loadingFiles addObject:filename];
    LoadTask *task = [[LoadTask alloc] initWithFilename:filename onComplete:onComplete 
                                                onError:onError];
    [task load];
}

- (void)loadTaskCompleted:(LoadTask *)task {
    NSAssert([_loadingFiles containsObject:task.filename], @"");
    [_loadingFiles removeObject:task.filename];
    
    NSException *loadErr = task.err;
    
    if (loadErr == nil) {
        @try {
            for (id<BTResource> rsrc in task.resources) {
                NSAssert(![self isLoaded:rsrc.name], 
                         @"A resource with that name already exists: '%@'", rsrc.name);
                [_resources setValue:rsrc forKey:rsrc.name];
            }
        } @catch (NSException *err) {
            [self unloadResourceFile:task.filename];
            loadErr = err;
        }
    }
    
    if (loadErr) task.onError(loadErr);
    else {
        [_loadedFiles addObject:task.filename];
        task.onComplete();
    }
}

- (id<BTResource>)getResource:(NSString *)name {
    return [_resources objectForKey:name];
}

- (id<BTResource>)requireResource:(NSString *)name {
    id<BTResource> rsrc = [self getResource:name];
    NSAssert(rsrc != nil, @"No such resource: %@", name);
    return rsrc;
}

- (BOOL)isLoaded:(NSString *)name {
    return [self getResource:name] != nil;
}

- (void)unloadResourceFile:(NSString *)filename {
    for (id<BTResource>rsrc in [_resources allValues]) {
        if ([rsrc.group isEqualToString:filename]) {
            [_resources removeObjectForKey:rsrc.name];
        }
    }
    [_loadedFiles removeObject:filename];
}

- (void)unloadAll {
    [_resources removeAllObjects];
    [_loadedFiles removeAllObjects];
    // TODO: what to do with loading files?
}

- (void)registerFactory:(id<BTResourceFactory>)factory forType:(NSString *)type {
    [_factories setObject:factory forKey:type];
}

- (id<BTResourceFactory>)getFactory:(NSString *)type {
    return [_factories objectForKey:type];
}

@end

@implementation LoadTask

@synthesize filename = _filename;
@synthesize err = _err;
@synthesize resources = _resources;
@synthesize onComplete = _onComplete;
@synthesize onError = _onError;

- (id)initWithFilename:(NSString *)filename onComplete:(BTCompleteCallback)onComplete 
               onError:(BTErrorCallback)onError {
    if (!(self = [super init])) {
        return nil;
    }
    _filename = filename;
    _onComplete = onComplete;
    _onError = onError;
    return self;
}

- (void)complete {
    [[BTResourceManager sharedManager] loadTaskCompleted:self];
}

- (void)begin {
    @try {
        NSString *strippedFilename = [_filename stringByDeletingPathExtension];
        NSString *extension = [_filename pathExtension];
        
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSData *data = [NSData dataWithContentsOfFile:
                        [bundle pathForResource:strippedFilename ofType:extension]];
        if (data == nil) {
            @throw [GDataXMLException withReason:@"Unable to load file '%@'", _filename];
        }
        
        NSError *err;
        GDataXMLDocument *xmldoc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&err];
        if (xmldoc == nil) {
            @throw [[NSException alloc] initWithName:NSGenericException 
                                              reason:[err localizedDescription] 
                                            userInfo:[err userInfo]];
        }
        
        // Create the resources
        NSMutableArray* resources = [NSMutableArray array];
        GDataXMLElement *root = [xmldoc rootElement];
        for (GDataXMLElement *child in [root elements]) {
            NSString *type = [child name];
            // find the resource factory for this type
            id<BTResourceFactory> factory = [[BTResourceManager sharedManager] getFactory:type];
            NSAssert(factory != nil, @"No ResourceFactory for '%@'", type);
            // create the resource
            NSString* name = [child stringAttribute:@"name"];
            id<BTResource> rsrc = [factory create:name group:_filename xml:child];
            // add it to the batch
            [resources addObject:rsrc];
        }
        _resources = resources;
    } @catch (NSException *err) {
        _err = err;
    }
    [self performSelectorOnMainThread:@selector(complete) withObject:nil waitUntilDone:NO];
}

- (void)load {
    [self performSelectorInBackground:@selector(begin) withObject:nil];
}

@end