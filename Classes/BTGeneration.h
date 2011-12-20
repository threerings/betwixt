//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTObject.h"
#import "RADoubleSignal.h"

@class BTModeStack;

@interface BTGeneration : BTContext {
@package
    BTModeStack *_stack;
@private
    NSMutableDictionary *_namedObjects;
}

@property(nonatomic,readonly) RADoubleSignal *enterFrame;
@end
