//
//  Betwixt - Copyright 2011 Three Rings Design

@protocol BTResource;
@protocol BTResourceFactory;

typedef void (^BTCompleteCallback)(void);
typedef void (^BTErrorCallback)(NSException *);

@interface BTResourceManager : NSObject {
@protected
    NSMutableDictionary* _factories;   // <String, GUResourceFactory>
    NSMutableDictionary* _resources;   // <String, GUResource>
}

+ (BTResourceManager *)sharedManager;
- (void)loadResourceFile:(NSString *)filename;
- (void)loadResourceFileAsync:(NSString *)filename 
                   onComplete:(BTCompleteCallback)completeCallback 
                      onError:(BTErrorCallback)errorCallback;
- (id<BTResource>)getResource:(NSString *)name;
- (id<BTResource>)requireResource:(NSString *)name;
- (BOOL)isLoaded:(NSString *)name;
- (void)unloadGroup:(NSString *)group;
- (void)unloadAll;
- (void)registerFactory:(id<BTResourceFactory>)factory forType:(NSString *)type;

@end
