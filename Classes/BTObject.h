//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>

@class BTGeneration;

@interface BTObject : NSObject {
@package
    BTObject* _next;//Managed by BTGeneration
    BOOL _removed;
    BTGeneration *_gen;
}

-(void) advanceTime:(double)seconds;
-(void) addedToGen;
-(void) removedFromGen;
@end
