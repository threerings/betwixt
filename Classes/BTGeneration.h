//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTObject.h"

@interface BTGeneration : BTContext {
@private
    BTObject *_head;
    NSMutableDictionary *_namedObjects;
}
@end