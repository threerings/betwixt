//
// Betwixt - Copyright 2012 Three Rings Design

@class BTMode;
@protocol BTNodeContainer;

@interface BTNode : NSObject {
@package
    id<BTNodeContainer> _parent;
    RAUnitSignal* _detached;
    RAConnectionGroup* _conns;
    BOOL _isDetached;
}

- (void)detach;

@property(nonatomic,readonly) RAUnitSignal* detached;
@property(nonatomic,readonly) BTMode* mode;
@property(nonatomic,readonly) RAConnectionGroup* conns;
@property(nonatomic,readonly) id<BTNodeContainer> parent;
@property(nonatomic,readonly) BOOL isAttached;
@property(nonatomic,readonly) BOOL isDetached;

@end
