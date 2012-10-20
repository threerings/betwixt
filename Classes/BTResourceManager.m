//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTResourceManager.h"
#import "BTResourceFactory.h"
#import "BTMultiResourceFactory.h"
#import "BTApp.h"
#import "BTApp+Package.h"
#import "BTResource.h"
#import "BTResource+Protected.h"
#import "GDataXMLException.h"

#import "GDataXMLNode+BTExtensions.h"
#import "SPView+BTExtensions.h"

@interface LoadTask : NSObject {
@public
    __weak BTResourceManager* _mgr;
    NSArray* _filenames;
    NSMutableDictionary* _resources; // <NSString*, NSArray*>

    NSException* _err;
}

- (id)initWithManager:(BTResourceManager*)mgr filenames:(NSArray*)filenames;
- (void)load;
- (void)loadAsync:(OOOUnitBlock)onComplete onError:(OOOErrorBlock)onError;

@property (readonly,strong) NSDictionary* resources;
@property (readonly,strong) NSException* err;
@property (copy) OOOUnitBlock onComplete;
@property (copy) OOOErrorBlock onError;
@property BOOL canceled;
@end

@implementation BTResourceManager

- (id)init {
    if ((self = [super init])) {
        _factories = [[NSMutableDictionary alloc] init];
        _resources = [[NSMutableDictionary alloc] init];
        _loadingFiles = [[NSMutableSet alloc] init];
        _loadedFiles = [[NSMutableSet alloc] init];
    }
    return self;
}

- (BOOL)isResourceFileLoaded:(NSString*)filename {
    return [_loadedFiles containsObject:filename] || [_loadingFiles containsObject:filename];
}

- (LoadTask*)createLoadTask:(NSArray*)filenames {
    for (NSString* filename in filenames) {
        if ([self isResourceFileLoaded:filename]) {
            [NSException raise:NSGenericException
                        format:@"Resource file '%@' already loaded (or is loading)", filename];
        }
    }
    [_loadingFiles addObjectsFromArray:filenames];
    return [[LoadTask alloc] initWithManager:self filenames:filenames];
}

- (void)loadResourceFiles:(NSArray*)filenames onComplete:(OOOUnitBlock)onComplete
                  onError:(OOOErrorBlock)onError {
    LoadTask* task = [self createLoadTask:filenames];
    [task loadAsync:onComplete onError:onError];
}

- (void)loadResourceFiles:(NSArray*)filenames {
    LoadTask* task = [self createLoadTask:filenames];
    [task load];
}

- (void)loadTaskCompleted:(LoadTask*)task {
    NSException* loadErr = task.err;

    // add all resources
    for (NSString* filename in task.resources.keyEnumerator) {
        NSAssert([_loadingFiles containsObject:filename], @"");
        [_loadingFiles removeObject:filename];

        NSArray* resources = [task.resources objectForKey:filename];
        if (task.canceled) {
            for (BTResource* rsrc in resources) {
                [rsrc unload];
            }

        } else if (loadErr == nil) {
            @try {
                for (BTResource* rsrc in resources) {
                    if ([self resourceExists:rsrc.name]) {
                        [NSException raise:NSGenericException
                                    format:@"A resource with that name already exists: '%@'", rsrc.name];
                    } else {
                        [_resources setValue:rsrc forKey:rsrc.name];
                    }
                }
            } @catch (NSException* err) {
                loadErr = err;
            }
        }
    }

    for (NSString* filename in task.resources.keyEnumerator) {
        if (loadErr == nil && !task.canceled) {
            [_loadedFiles addObject:filename];
        } else if (loadErr != nil) {
            [self unloadResourceFile:filename];
        }
    }

    if (loadErr != nil) {
        task.onError(loadErr);
    } else {
        task.onComplete();
    }
}

- (id)getResource:(NSString*)name {
    return _resources[name];
}

- (id)requireResource:(NSString*)name {
    BTResource* rsrc = [self getResource:name];
    NSAssert(rsrc != nil, @"No such resource: %@", name);
    return rsrc;
}

- (id)requireResource:(NSString*)name ofType:(__unsafe_unretained Class)clazz {
    BTResource* rsrc = [self requireResource:name];
    NSAssert([rsrc isKindOfClass:clazz], @"Resource is the wrong type "
             "[name='%@' expectedType=%@ actualType=%@]", name, clazz, [rsrc class]);
    return rsrc;
}

- (id)requireResource:(NSString*)name conformingTo:(Protocol*)proto {
    BTResource* rsrc = [self requireResource:name];
    NSAssert([rsrc conformsToProtocol:proto], @"Resource is the wrong type "
             "[name='%@' expectedType=%@ actualType=%@]", name, proto, [rsrc class]);
    return rsrc;
}

- (BOOL)resourceExists:(NSString*)name {
    return [self getResource:name] != nil;
}

- (void)unloadResourceFiles:(NSArray*)filenames {
    for (NSString* filename in filenames) {
        [self unloadResourceFile:filename];
    }
}

- (void)unloadResourceFile:(NSString*)filename {
    for (BTResource* rsrc in _resources.allValues) {
        if ([rsrc.group isEqualToString:filename]) {
            [_resources removeObjectForKey:rsrc.name];
            [rsrc unload];
        }
    }
    [_loadedFiles removeObject:filename];
}

- (void)unloadAll {
    for (BTResource* rsrc in _resources.allValues) {
        [rsrc unload];
    }
    [_resources removeAllObjects];
    [_loadedFiles removeAllObjects];

    for (LoadTask* task in _loadingFiles) {
        task.canceled = YES;
    }
}

- (void)registerFactory:(id<BTResourceFactory>)factory forType:(NSString*)type {
    _factories[type] = factory;
}

- (void)registerMultiFactory:(id<BTMultiResourceFactory>)factory forType:(NSString*)type {
    _factories[type] = factory;
}

- (id<BTResourceFactory>)getFactory:(NSString*)type {
    return _factories[type];
}

@end

@implementation LoadTask

@synthesize err = _err;
@synthesize resources = _resources;
@synthesize onComplete, onError, canceled;

- (id)initWithManager:(BTResourceManager*)mgr filenames:(NSArray*)filenames {
    if ((self = [super init])) {
        _mgr = mgr;
        _filenames = filenames;
        _resources = [[NSMutableDictionary alloc] initWithCapacity:_filenames.count];
    }
    return self;
}

- (void)complete {
    [_mgr loadTaskCompleted:self];
}

- (void)loadNow {
    if (self.canceled) {
        return;
    }

    for (NSString* filename in _filenames) {
        NSData* data = [BTApp loadFileAt:filename];

        NSError* err;
        GDataXMLDocument* xmldoc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&err];
        if (xmldoc == nil) {
            @throw [[NSException alloc] initWithName:NSGenericException
                                              reason:[err localizedDescription]
                                            userInfo:[err userInfo]];
        }

        // Create the resources
        NSMutableArray* resources = [NSMutableArray array];
        GDataXMLElement* root = [xmldoc rootElement];
        for (GDataXMLElement* child in [root elements]) {
            NSString* type = [child name];
            // find the resource factory for this type
            id factory = [_mgr getFactory:type];
            if (factory == nil) {
                @throw [GDataXMLException withElement:child
                                               reason:@"No ResourceFactory for '%@'", type];
            }

            if ([factory conformsToProtocol:@protocol(BTMultiResourceFactory)]) {
                for (BTResource* rsrc in [((id<BTMultiResourceFactory>)factory) create:child]) {
                    rsrc->_group = filename;
                    // add it to the batch
                    [resources addObject:rsrc];
                }
            } else {
                NSAssert([factory conformsToProtocol:@protocol(BTResourceFactory)],
                         @"Factory for '%@', '%@', doesn't conform to BTResourceFactory or BTMultiResourceFactory", type, factory);
                // create the resource
                NSString* name = [child stringAttribute:@"name"];
                BTResource* rsrc = [factory create:child];
                rsrc->_name = name;
                rsrc->_group = filename;
                // add it to the batch
                [resources addObject:rsrc];
            }
        }

        _resources[filename] = resources;
    }
}

- (void)loadInBackground {
    @try {
        if (![BTApp.view useNewSharedEAGLContext]) {
            [NSException raise:NSGenericException format:@"Unable to use new EAGLContext"];
        }
        [self loadNow];
    } @catch (NSException* err) {
        _err = err;
    }

    [self performSelectorOnMainThread:@selector(complete) withObject:nil waitUntilDone:NO];
}

- (void)load {
    self.onComplete = ^{};
    self.onError = ^(NSException* err) { [err raise]; };

    @try {
        [self loadNow];
    } @catch (NSException* err) {
        _err = err;
    }
    [self complete];
}

- (void)loadAsync:(OOOUnitBlock)completeBlock onError:(OOOErrorBlock)errBlock {
    self.onComplete = completeBlock;
    self.onError = errBlock;
    [self performSelectorInBackground:@selector(loadInBackground) withObject:nil];
}

@end
