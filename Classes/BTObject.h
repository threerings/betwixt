//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTContext.h"

@class BTGeneration;

@interface BTObject : BTContext {
@package//Managed by BTGeneration
    BTObject *_next;
    BTGeneration *_gen;
    BTObject *_depHead;
}

- (NSArray*)names;
- (void)addDependentObject:(BTObject*)object;

@end
