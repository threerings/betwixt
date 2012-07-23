//
// Betwixt - Copyright 2012 Three Rings Design

@class BTResource;
@protocol BTMultiResourceFactory;
@protocol BTResourceFactory;

@interface BTResourceManager : NSObject {
@protected
    NSMutableDictionary* _factories;   // <String, BTResourceFactory>
    NSMutableDictionary* _resources;   // <String, BTResource>
    NSMutableSet* _loadingFiles; // <String>
    NSMutableSet* _loadedFiles; // <String>
    NSString* _pathPrefix;
}

/// Loads resource files synchronously
- (void)loadResourceFiles:(NSArray*)filenames;
- (void)loadResourceFile:(NSString*)filename;

/// Loads resource files in the background
- (void)loadResourceFiles:(NSArray*)filenames onComplete:(OOOUnitBlock)onComplete
                  onError:(OOOErrorBlock)onError;
- (void)loadResourceFile:(NSString*)filename onComplete:(OOOUnitBlock)onComplete
                 onError:(OOOErrorBlock)onError;

- (void)unloadResourceFile:(NSString*)filename;
- (id)getResource:(NSString*)name;
- (id)requireResource:(NSString*)name;
- (id)requireResource:(NSString*)name ofType:(Class)clazz;
- (id)requireResource:(NSString*)name conformingTo:(Protocol*)proto;
- (BOOL)isResourceLoaded:(NSString*)name;
- (void)registerFactory:(id<BTResourceFactory>)factory forType:(NSString*)type;
- (void)registerMultiFactory:(id<BTMultiResourceFactory>)factory forType:(NSString*)type;
- (void)unloadAll;

@end
