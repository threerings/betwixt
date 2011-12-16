//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTContext.h"

@class BTGeneration;

@interface BTObject : BTContext {
    @package
        BTContext *_parent;
}

- (NSArray*)names;

@property(nonatomic,readonly,strong) BTContext *parent;

@end
