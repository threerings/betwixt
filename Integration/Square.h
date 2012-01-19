//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTDisplayable.h"
#import "BTObject.h"
#import "BTKeyed.h"
#import "BTUpdatable.h"

#define SQUARE_FRAME_PRIORITY RA_DEFAULT_PRIORITY

@interface Square : BTObject <BTKeyed,BTDisplayable,BTUpdatable> {
@private
    SPQuad *_quad;
    NSString *_name;
}

- (id)initWithColor:(int)color andName:(NSString*)name;
- (void)update:(float)dt;

@end
