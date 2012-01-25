//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTResourceManager.h"
#import "BTResourceFactory.h"
#import "BTResource.h"
#import "GDataXMLException.h"

#import "GDataXMLNode+OOO.h"

@interface BTResourceFile () {
@private
    NSString *_filename;
    NSMutableSet *_referencedFiles;
}
- (id)initWithFilename:(NSString *)filename;
- (void)addReferencedFile:(BTResourceFile *)file;
- (void)load:(BTCompleteCallback)onComplete onError:(BTErrorCallback)onError;
- (void)dealloc;
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
    _resourceFiles = [[NSMutableDictionary alloc] init];
    return self;
}

- (BTResourceFile *)getResourceFile:(NSString *)name {
    NSValue *weakVal = [_resourceFiles objectForKey:name];
    return (BTResourceFile *) [weakVal nonretainedObjectValue];
}

- (void)loadResourceFile:(NSString *)filename onComplete:(BTCompleteCallback)onComplete 
                 onError:(BTErrorCallback)onError {
    NSAssert([self getResourceFile:filename] == nil, @"Resource file '%@' already loaded", filename);
    BTResourceFile *file = [[BTResourceFile alloc] initWithFilename:filename];
    // store a weak reference to the file in our dictionary
    [_resourceFiles setObject:[NSValue valueWithNonretainedObject:file] forKey:filename];
    [file load:onComplete onError:onError];
}

- (void)addResources:(NSArray *)resources {
    for (id<BTResource> rsrc in resources) {
        NSAssert(![self isLoaded:rsrc.name], @"A resource with that name already exists: '%@'", 
                 rsrc.name);
        [_resources setValue:rsrc forKey:rsrc.name];
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

- (void)unloadGroup:(NSString *)group {
    for (id<BTResource>rsrc in [_resources allValues]) {
        if ([rsrc.group isEqualToString:group]) {
            [_resources removeObjectForKey:rsrc.name];
        }
    }
}

- (void)registerFactory:(id<BTResourceFactory>)factory forType:(NSString *)type {
    [_factories setObject:factory forKey:type];
}

- (id<BTResourceFactory>)getFactory:(NSString *)type {
    return [_factories objectForKey:type];
}

@end

@interface LoadTask : NSObject {
@public
    BTCompleteCallback _onComplete;
    BTErrorCallback _onError;
}
@property (strong) NSArray *resources;
@property (strong) NSException *err;
@property (readonly) BTCompleteCallback onComplete;
@property (readonly) BTErrorCallback onError;
- (id)init:(BTCompleteCallback)onComplete onError:(BTErrorCallback)onError;
@end

@implementation LoadTask

@synthesize resources;
@synthesize err;
@synthesize onComplete = _onComplete;
@synthesize onError = _onError;

- (id)init:(BTCompleteCallback)onComplete onError:(BTErrorCallback)onError {
    if (!(self = [super init])) {
        return nil;
    }
    _onComplete = onComplete;
    _onError = onError;
    return self;
}

@end

@implementation BTResourceFile

- (id)initWithFilename:(NSString *)filename {
    if (!(self = [super init])) {
        return nil;
    }
    _filename = filename;
    return self;
}

- (void)addReferencedFile:(BTResourceFile *)file {
    if (_referencedFiles == nil) {
        _referencedFiles = [NSMutableSet setWithObject:file];
    } else {
        [_referencedFiles addObject:file];
    }
}

- (void)complete:(LoadTask *)task {
    if (task.err == nil) {
        @try {
            [[BTResourceManager sharedManager] addResources:task.resources];
        }
        @catch (NSException *exception) {
            task.err = exception;
        }
    }
    
    if (task.err != nil) {
        task.onError(task.err);
    } else {
        task.onComplete(self);
    }
}

- (void)begin:(LoadTask *)task {
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
        task.resources = resources;
    } @catch (NSException *err) {
        task.err = err;
    }
    [self performSelectorOnMainThread:@selector(complete:) withObject:task waitUntilDone:NO];
}

- (void)load:(BTCompleteCallback)onComplete onError:(BTErrorCallback)onError {
    LoadTask *task = [[LoadTask alloc] init:onComplete onError:onError];
    [self performSelectorInBackground:@selector(begin:) withObject:task];
}

- (void)dealloc {
    [[BTResourceManager sharedManager] unloadGroup:_filename];
}

@synthesize filename = _filename;

@end