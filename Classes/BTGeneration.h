//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTObject.h"

@class BTModeStack;

@interface BTGeneration : BTContext {
@package
    BTModeStack *_stack;
@private
    BTObject *_head;
    NSMutableDictionary *_namedObjects;
}
@end