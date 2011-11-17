//
//  Bangalaclang - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "SPSprite.h"
#import "BCMode.h"

@interface BCModeStack : NSObject {
@package
    SPSprite *_sprite;
}

- (void)pushMode:(BCMode*)mode;

@end
