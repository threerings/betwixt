//
//  Betwixt - Copyright 2011 Three Rings Design

@protocol BTResource;
@protocol BTResourceFactory;
@class LoadTask;

typedef void (^BTCompleteCallback)(void);
typedef void (^BTErrorCallback)(NSException *);

@interface BTResourceManager : NSObject {
@protected
    NSMutableDictionary *_factories;   // <String, BTResourceFactory>
    NSMutableDictionary *_resources;   // <String, BTResource>
    LoadTask *_pendingLoadTask;
}

+ (BTResourceManager *)sharedManager;
- (void)loadResourceFile:(NSString *)filename;
- (void)pendResourceFile:(NSString *)filename;
- (void)loadPendingResources:(BTCompleteCallback)completeCallback 
                     onError:(BTErrorCallback)errorCallback;
- (id<BTResource>)getResource:(NSString *)name;
- (id<BTResource>)requireResource:(NSString *)name;
- (BOOL)isLoaded:(NSString *)name;
- (void)unloadGroup:(NSString *)group;
- (void)unloadAll;
- (void)registerFactory:(id<BTResourceFactory>)factory forType:(NSString *)type;

@end
