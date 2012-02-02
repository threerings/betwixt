//
// Betwixt - Copyright 2012 Three Rings Design

@class BTMode;
@protocol BTNodeContainer;

@interface BTNode : NSObject {
@package
    id<BTNodeContainer> _parent;
    RAUnitSignal *_attached;
    RAUnitSignal *_detached;
    RAConnectionGroup *_conns;
}

- (void)detach;

@property(nonatomic,readonly) RAUnitSignal *attached;
@property(nonatomic,readonly) RAUnitSignal *detached;
@property(nonatomic,readonly) BTMode *mode;
@property(nonatomic,readonly) RAConnectionGroup *conns;
@property(nonatomic,readonly) id<BTNodeContainer> parent;

@end
