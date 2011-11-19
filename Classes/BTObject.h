//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>

@class BTGeneration;

@interface BTObject : NSObject {
@package//Managed by BTGeneration
    BTObject* _next;
    BOOL _removed;
    BTGeneration *_gen;
    BTObject* _depHead;
}

-(NSArray*) names;
-(void) advanceTime:(double)seconds;
-(void) addedToGen;
-(void) removedFromGen;
-(void) addDependentObject:(BTObject*)object;
@end
