//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>

#import "BTKeyed.h"

@interface BTMode (package)

-(void)enterFrame:(SPEnterFrameEvent*)ev;
-(void)addKeys:(BTNode<BTKeyed>*)object;

@end
