//
//  Betwixt - Copyright 2011 Three Rings Design

@protocol BTResource;
@protocol BTResourceFactory;

@interface BTResourceFile : NSObject
@property (readonly) NSString *filename;
@end

typedef void (^BTCompleteCallback)(BTResourceFile *handle);
typedef void (^BTErrorCallback)(NSException *);

@interface BTResourceManager : NSObject {
@protected
    NSMutableDictionary *_factories;   // <String, BTResourceFactory>
    NSMutableDictionary *_resources;   // <String, BTResource>
    NSMutableDictionary *_resourceFiles; // <String, NSValue<BTResourceFile>>
}

+ (BTResourceManager *)sharedManager;
- (void)loadResourceFile:(NSString *)filename onComplete:(BTCompleteCallback)onComplete 
                 onError:(BTErrorCallback)onError;
- (id<BTResource>)getResource:(NSString *)name;
- (id<BTResource>)requireResource:(NSString *)name;
- (BOOL)isLoaded:(NSString *)name;
- (void)registerFactory:(id<BTResourceFactory>)factory forType:(NSString *)type;

@end
