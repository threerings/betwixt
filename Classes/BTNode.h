//
// Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>

@class BTGeneration;
@class BTContext;

@interface BTNode : NSObject {
@package
    BTContext *_parent;
    RAUnitSignal *_attached;
    RAUnitSignal *_detached;
    RAConnectionGroup *_conns;
}

- (void)detach;

@property(nonatomic,readonly) RAUnitSignal *attached;
@property(nonatomic,readonly) RAUnitSignal *detached;
@property(nonatomic,readonly) BTGeneration *root;
@property(nonatomic,readonly) RAConnectionGroup *conns;
@property(nonatomic,readonly) BTContext *parent;


@end
