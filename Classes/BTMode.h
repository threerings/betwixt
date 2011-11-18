//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "SPSprite.h"

@interface BTMode : NSObject {
@private
    SPSprite *_sprite;
}

-(void)advanceTime:(double)seconds;

@property(readonly, strong, nonatomic) SPSprite *sprite;

@end
