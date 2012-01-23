//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTResourceManager.h"
#import "BTResourceFactory.h"
#import "BTResource.h"
#import "GDataXMLException.h"

#import "GDataXMLNode+OOO.h"

@interface BackroundLoadTask : NSObject {
@public
    NSString *_filename;
    BTCompleteCallback _onComplete;
    BTErrorCallback _onError;
    NSArray *_resources;
    NSException *_err;
}
- (id)initWithFilename:(NSString *)filename onComplete:(BTCompleteCallback)onComplete 
               onError:(BTErrorCallback) onError;
- (void)load;
@end

@interface BTResourceManager ()
- (id<BTResourceFactory>)getFactory:(NSString *)type;
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
    return self;
}

- (NSArray *)getResourcesFromFile:(NSString *)filename {
    NSString *strippedFilename = [filename stringByDeletingPathExtension];
    NSString *extension = [filename pathExtension];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSData *data = [NSData dataWithContentsOfFile:
                    [bundle pathForResource:strippedFilename ofType:extension]];
    if (data == nil) {
        @throw [GDataXMLException withReason:@"Unable to load file '%@'", filename];
    }
    
    NSError *err;
    GDataXMLDocument *xmldoc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&err];
    if (xmldoc == nil) {
        @throw [[NSException alloc] initWithName:NSGenericException 
                                          reason:[err localizedDescription] 
                                        userInfo:[err userInfo]];
    }
    
    // Create the resources
    NSMutableArray *resources = [NSMutableArray array];
    GDataXMLElement *root = [xmldoc rootElement];
    for (GDataXMLElement *child in [root elements]) {
        NSString *type = [child name];
        // find the resource factory for this type
        id<BTResourceFactory> factory = [self getFactory:type];
        NSAssert(factory != nil, @"No ResourceFactory for '%@'", type);
        // create the resource
        NSString* name = [child stringAttribute:@"name"];
        id<BTResource> rsrc = [factory create:name group:filename xml:child];
        // add it to the batch
        [resources setValue:rsrc forKey:name];
    }
    
    return resources;
}

- (void)addResources:(NSArray *)resources {
    for (id<BTResource> rsrc in resources) {
        NSAssert(![self isLoaded:rsrc.name], @"A resource with that name already exists: '%@'", 
                 rsrc.name);
        [_resources setValue:rsrc forKey:rsrc.name];
    }
}

- (void)loadResourceFile:(NSString *)filename {
    [self addResources:[self getResourcesFromFile:filename]];
}

- (void)loadResourceFileAsync:(NSString *)filename onComplete:(BTCompleteCallback)completeCallback 
                      onError:(BTErrorCallback)errorCallback {
    [[[BackroundLoadTask alloc] initWithFilename:filename 
                                      onComplete:completeCallback 
                                         onError:errorCallback] load];
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

- (void)unloadAll {
    [_resources removeAllObjects];
}

- (void)registerFactory:(id<BTResourceFactory>)factory forType:(NSString *)type {
    [_factories setObject:factory forKey:type];
}

- (id<BTResourceFactory>)getFactory:(NSString *)type {
    return [_factories objectForKey:type];
}

@end

@implementation BackroundLoadTask

- (id)initWithFilename:(NSString *)filename 
            onComplete:(BTCompleteCallback)onComplete 
               onError:(BTErrorCallback) onError {
    
    if (!(self = [super init])) {
        return nil;
    }
    _filename = filename;
    _onComplete = onComplete;
    _onError = onError;
    return self;
}

- (void)complete {
    if (_err != nil) {
        @try {
            [[BTResourceManager sharedManager] addResources:_resources];
        }
        @catch (NSException *exception) {
            _err = exception;
        }
    }
    
    if (_err != nil) {
        _onError(_err);
    } else {
        _onComplete();
    }
}

- (void)begin {
    @try {
        _resources = [[BTResourceManager sharedManager] getResourcesFromFile:_filename];
    } @catch (NSException *err) {
        _err = err;
    }
    [self performSelectorOnMainThread:@selector(complete) withObject:nil waitUntilDone:NO];
}

- (void)load {
    [self performSelectorInBackground:@selector(begin) withObject:nil];
}

@end
