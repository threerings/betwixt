//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "NSObject+BlockObservation.h"

#define OBSERVE(OBJ, PATH, CODE) \
[(OBJ) attachObserverForKeyPath:(PATH) task:^(id obj, NSDictionary *change) { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-retain-cycles\"") \
do { CODE; } while(0); \
_Pragma("clang diagnostic pop") \
}];

@class BTGeneration;

@interface BTObject : NSObject {
@private
    NSMutableSet *_tokens;
@package//Managed by BTGeneration
    BTObject *_next;
    BTGeneration *_gen;
    BTObject *_depHead;
}

- (NSArray*)names;
- (void)advanceTime:(double)seconds;
- (void)addDependentObject:(BTObject*)object;
- (AMBlockToken*)attachObserverForKeyPath:(NSString*)path task:(AMBlockTask)task;
- (void)detachObserverForToken:(AMBlockToken*)token;

@property(nonatomic) BOOL added;
@property(nonatomic) BOOL removed;

@end
