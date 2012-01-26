//
// Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>

@class BTMode;
@class BTNodeContainer;

@interface BTNode : NSObject {
@package
    BTNodeContainer *_parent;
    RAUnitSignal *_attached;
    RAUnitSignal *_detached;
    RAConnectionGroup *_conns;
}

- (void)detach;

@property(nonatomic,readonly) RAUnitSignal *attached;
@property(nonatomic,readonly) RAUnitSignal *detached;
@property(nonatomic,readonly) BTMode *mode;
@property(nonatomic,readonly) RAConnectionGroup *conns;
@property(nonatomic,readonly) BTNodeContainer *parent;


@end
