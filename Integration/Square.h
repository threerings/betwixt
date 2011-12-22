//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTDisplayable.h"
#import "BTObject.h"
#import "BTNamed.h"

#define SQUARE_FRAME_PRIORITY RA_DEFAULT_PRIORITY

@interface Square : BTObject <BTNamed,BTDisplayable> {
@private
    SPQuad *_quad;
    NSString *_name;
}

- (id)initWithColor:(int)color andName:(NSString*)name;

@end
