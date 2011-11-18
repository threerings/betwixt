//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "SPSprite.h"
#import "BTMode.h"

@interface BTModeStack : NSObject {
@package
    SPSprite *_sprite;
}

- (void)pushMode:(BTMode*)mode;

- (void)advanceTime:(double)seconds;

@end
