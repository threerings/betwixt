//
//  Betwixt - Copyright 2012 Three Rings Design

#import "BTResource.h"
#import "BTMultiResourceFactory.h"

#define BTATLAS_RESOURCE_NAME @"atlas"

@protocol BTMultiResourceFactory;

@interface BTAtlasFactory : NSObject<BTMultiResourceFactory>

+ (id<BTMultiResourceFactory>) sharedFactory;

@end
