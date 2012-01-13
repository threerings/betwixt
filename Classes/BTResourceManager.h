//
//  Betwixt - Copyright 2011 Three Rings Design

@class BTResource;
@protocol BTResourceFactory;

@interface BTResourceManager : NSObject {
@protected
    NSMutableDictionary* _factories;   // <String, GUResourceFactory>
    NSMutableDictionary* _resources;   // <String, GUResource>
}

+ (BTResourceManager *)sharedManager;
- (BTResource *)getResource:(NSString *)name;
- (BTResource *)requireResource:(NSString *)name;
- (BOOL)isLoaded:(NSString *)name;
- (void)unloadGroup:(NSString *)group;
- (void)unloadAll;
- (void)registerFactory:(id<BTResourceFactory>)factory forType:(NSString *)type;
- (id<BTResourceFactory>)getFactory:(NSString *)type;

@end
