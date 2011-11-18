//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTObject.h"

@interface BTGeneration : NSObject {
@private
    BTObject* _head;
}
-(void) addObject:(BTObject *)object;
-(void) removeObject:(BTObject *)object;
-(void) advanceTime:(double)seconds;
@end
