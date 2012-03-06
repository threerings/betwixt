//
// Betwixt - Copyright 2012 Three Rings Design

#import "BTCallbacks.h"

@protocol BTMultiResourceFactory;
@class BTResource;
@protocol BTResourceFactory;

@interface BTResourceManager : NSObject {
@protected
    NSMutableDictionary* _factories;   // <String, BTResourceFactory>
    NSMutableDictionary* _resources;   // <String, BTResource>
    NSMutableSet* _loadingFiles; // <String>
    NSMutableSet* _loadedFiles; // <String>
}

/// Loads a resource file synchronously
- (void)loadResourceFile:(NSString*)filename;

/// Loads a resource file in the background
- (void)loadResourceFile:(NSString*)filename onComplete:(BTCompleteCallback)onComplete
                 onError:(BTErrorCallback)onError;

- (void)unloadResourceFile:(NSString*)filename;
- (id)getResource:(NSString*)name;
- (id)requireResource:(NSString*)name;
- (id)requireResource:(NSString*)name ofType:(Class)clazz;
- (id)requireResource:(NSString*)name conformingTo:(Protocol*)proto;
- (BOOL)isLoaded:(NSString*)name;
- (void)registerFactory:(id<BTResourceFactory>)factory forType:(NSString*)type;
- (void)registerMultiFactory:(id<BTMultiResourceFactory>)factory forType:(NSString*)type;
- (void)unloadAll;

@end
