//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTResourceManager.h"
#import "BTResourceFactory.h"
#import "BTMultiResourceFactory.h"
#import "BTApp.h"
#import "BTApp+Package.h"
#import "BTResource.h"
#import "GDataXMLException.h"

#import "GDataXMLNode+Extensions.h"
#import "SPView+Extensions.h"

@interface LoadTask : NSObject

- (id)initWithManager:(BTResourceManager*)mgr filename:(NSString*)filename;
- (void)load;
- (void)loadAsync:(BTCompleteCallback)onComplete onError:(BTErrorCallback)onError;

@property (readonly,strong) NSString* filename;
@property (readonly,strong) NSArray* resources;
@property (readonly,strong) NSException* err;
@property (copy) BTCompleteCallback onComplete;
@property (copy) BTErrorCallback onError;
@end

@implementation BTResourceManager

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

- (BOOL)isResourceFileLoaded:(NSString*)filename {
    return [_loadedFiles containsObject:filename] || [_loadingFiles containsObject:filename];
}

- (LoadTask*)createLoadTask:(NSString*)filename {
    NSAssert(![self isResourceFileLoaded:filename],
             @"Resource file '%@' already loaded (or is loading)", filename);
    
    [_loadingFiles addObject:filename];
    return [[LoadTask alloc] initWithManager:self filename:filename];
}

- (void)loadResourceFile:(NSString*)filename onComplete:(BTCompleteCallback)onComplete
                 onError:(BTErrorCallback)onError {
    LoadTask* task = [self createLoadTask:filename];
    [task loadAsync:onComplete onError:onError];
}

- (void)loadResourceFile:(NSString*)filename {
    LoadTask* task = [self createLoadTask:filename];
    [task load];
}

- (void)loadTaskCompleted:(LoadTask*)task {
    NSAssert([_loadingFiles containsObject:task.filename], @"");
    [_loadingFiles removeObject:task.filename];

    NSException* loadErr = task.err;

    if (loadErr == nil) {
        @try {
            for (BTResource* rsrc in task.resources) {
                NSAssert(![self isResourceLoaded:rsrc.name],
                         @"A resource with that name already exists: '%@'", rsrc.name);
                [_resources setValue:rsrc forKey:rsrc.name];
            }
        } @catch (NSException* err) {
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

- (id)getResource:(NSString*)name {
    return [_resources objectForKey:name];
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

- (BOOL)isResourceLoaded:(NSString*)name {
    return [self getResource:name] != nil;
}

- (void)unloadResourceFile:(NSString*)filename {
    for (BTResource* rsrc in [_resources allValues]) {
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

- (void)registerFactory:(id<BTResourceFactory>)factory forType:(NSString*)type {
    [_factories setObject:factory forKey:type];
}

- (void)registerMultiFactory:(id<BTMultiResourceFactory>)factory forType:(NSString*)type {
    [_factories setObject:factory forKey:type];
}

- (id<BTResourceFactory>)getFactory:(NSString*)type {
    return [_factories objectForKey:type];
}

@end

@implementation LoadTask {
@public
    __weak BTResourceManager* _mgr;
    NSString* _filename;
    NSArray* _resources;
    
    NSException* _err;
}

@synthesize filename = _filename;
@synthesize err = _err;
@synthesize resources = _resources;
@synthesize onComplete, onError;

- (id)initWithManager:(BTResourceManager*)mgr filename:(NSString*)filename {
    if (!(self = [super init])) {
        return nil;
    }
    _mgr = mgr;
    _filename = filename;
    return self;
}

- (void)complete {
    [_mgr loadTaskCompleted:self];
}

- (void)loadNow {
    @try {
        if (![BTApp.view useNewSharedEAGLContext]) {
            [NSException raise:NSGenericException format:@"Unable to use new EAGLContext"];
        }
        NSString* path = [BTApp resourcePathFor:_filename];
        
        NSData* data = [NSData dataWithContentsOfFile:path];
        if (data == nil) {
            @throw [GDataXMLException withReason:@"Unable to load file '%@'", _filename];
        }
        
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
            NSAssert(factory, @"No ResourceFactory for '%@'", type);
            if ([factory conformsToProtocol:@protocol(BTMultiResourceFactory)]) {
                for (BTResource* rsrc in [((id<BTMultiResourceFactory>)factory) create:child]) {
                    rsrc->_group = _filename;
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
                rsrc->_group = _filename;
                // add it to the batch
                [resources addObject:rsrc];
            }
        }
        _resources = resources;
    } @catch (NSException* err) {
        _err = err;
    }
}

- (void)loadInBackground {
    [self loadNow];
    [self performSelectorOnMainThread:@selector(complete) withObject:nil waitUntilDone:NO];
}

- (void)load {
    self.onComplete = ^{};
    self.onError = ^(NSException* err) { [err raise]; };
    
    [self loadNow];
    [self complete];
}

- (void)loadAsync:(BTCompleteCallback)completeBlock onError:(BTErrorCallback)errBlock {
    self.onComplete = completeBlock;
    self.onError = errBlock;
    [self performSelectorInBackground:@selector(loadInBackground) withObject:nil];
}

@end
