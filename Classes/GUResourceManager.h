//
// gulp - Copyright 2011 Three Rings Design

@class GUResource;
@protocol GUResourceFactory;

@interface GUResourceManager : NSObject {
@protected
    NSMutableDictionary* _factories;   // <String, GUResourceFactory>
    NSMutableDictionary* _resources;   // <String, GUResource>
}

+ (GUResourceManager *)sharedManager;
- (GUResource *)getResource:(NSString *)name;
- (GUResource *)requireResource:(NSString *)name;
- (BOOL)isLoaded:(NSString *)name;
- (void)unloadGroup:(NSString *)group;
- (void)unloadAll;
- (void)registerType:(NSString *)type toFactory:(id<GUResourceFactory>)factory;
- (id<GUResourceFactory>)getFactory:(NSString *)type;
- (void)add:(GUResource *)rsrc;

@end
