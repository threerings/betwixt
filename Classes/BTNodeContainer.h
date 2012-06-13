//
// Betwixt - Copyright 2012 Three Rings Design

@class BTNode;
@class BTMode;
@class BTViewObject;

@protocol BTNodeContainer

@property (nonatomic,readonly) BOOL isLive;

- (BTMode*)mode;

- (void)addNode:(BTNode*)node;
- (void)addNode:(BTNode*)node withName:(NSString*)name;
- (void)addNode:(BTNode*)node withName:(NSString*)name replaceExisting:(BOOL)replaceExisting;
- (void)addNode:(BTViewObject*)node displayOn:(SPDisplayObjectContainer*)displayParent;

- (BTNode*)nodeForName:(NSString*)name;
- (void)removeNode:(BTNode*)node;

@end
