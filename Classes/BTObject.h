//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTContext.h"

@class BTGeneration;

@interface BTObject : BTContext {
@package
    BTObject *_next;
    BTObject *_depHead;
    BTContext *_parent;
}

- (NSArray*)names;
@property(nonatomic,readonly) BTGeneration *root;
@property(nonatomic,readonly,strong) BTContext *parent;

@end
