//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "NSObject+BlockObservation.h"

@class BTGeneration;

@interface BTObject : NSObject {
@package//Managed by BTGeneration
    BTObject *_next;
    BTGeneration *_gen;
    BTObject *_depHead;
}

- (NSArray*)names;
- (void)advanceTime:(double)seconds;
- (void)addDependentObject:(BTObject*)object;

@property(nonatomic) BOOL added;
@property(nonatomic) BOOL removed;

@end
