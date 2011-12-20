//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTObject.h"
#import "BTNamed.h"

#define SQUARE_FRAME_PRIORITY RA_DEFAULT_PRIORITY

@interface Square : BTObject <BTNamed> {
@private
    SPQuad *_quad;
    NSString *_name;
    int _color;
}

- (id)initWithColor:(int)color andName:(NSString*)name;

@end
