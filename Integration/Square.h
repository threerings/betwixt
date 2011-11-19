//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>
#import "BTObject.h"

@interface Square : BTObject
{
    @private
    SPQuad *_quad;
    int _color;
}
-(id)initWithColor:(int)color;

@end