//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTDisplayable.h"
#import "BTObject.h"
#import "BTKeyed.h"

#define SQUARE_FRAME_PRIORITY RA_DEFAULT_PRIORITY

@interface Square : BTObject <BTKeyed,BTDisplayable> {
@private
    SPQuad *_quad;
    NSString *_name;
}

- (id)initWithColor:(int)color andName:(NSString*)name;

@end
