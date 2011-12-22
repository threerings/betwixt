//
// Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>

#import "BTDisplayable.h"
#import "BTNode.h"

@protocol BTDisplayContext
- (void)displayNode:(BTNode<BTDisplayable>*)node;
@end
