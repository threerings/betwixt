//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>

#import "BTGrouped.h"
#import "BTKeyed.h"

@interface BTMode (package)

-(void)addKeys:(BTNode<BTKeyed>*)object;
-(void)addGroups:(BTNode<BTGrouped>*)object;

@end
