//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPEventDispatcher+BlockListener.h"

@class BTNode;
@class BTMode;
@class BTDisplayObject;

@protocol BTNodeContainer

- (BTMode*)mode;

- (void)addNode:(BTNode*)node;
- (void)addNode:(BTNode*)node withName:(NSString*)name;
- (void)addNode:(BTNode*)node withName:(NSString*)name replaceExisting:(BOOL)replaceExisting;
- (void)addNode:(BTDisplayObject*)node displayOn:(SPDisplayObjectContainer*)displayParent;

- (BTNode*)nodeForName:(NSString*)name;
- (void)removeNode:(BTNode*)node;

@end
