//
//  Betwixt - Copyright 2011 Three Rings Design

#import "BTCallbacks.h"

@protocol BTResource;
@protocol BTResourceFactory;

@interface BTResourceManager : NSObject {
@protected
    NSMutableDictionary *_factories;   // <String, BTResourceFactory>
    NSMutableDictionary *_resources;   // <String, BTResource>
    NSMutableSet *_loadingFiles; // <String>
    NSMutableSet *_loadedFiles; // <String>
}

- (void)loadResourceFile:(NSString *)filename onComplete:(BTCompleteCallback)onComplete 
                 onError:(BTErrorCallback)onError;
- (void)unloadResourceFile:(NSString *)filename;
- (id<BTResource>)getResource:(NSString *)name;
- (id<BTResource>)requireResource:(NSString *)name;
- (BOOL)isLoaded:(NSString *)name;
- (void)registerFactory:(id<BTResourceFactory>)factory forType:(NSString *)type;
- (void)unloadAll;

@end
