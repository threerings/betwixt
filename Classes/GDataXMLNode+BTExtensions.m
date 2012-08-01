//
// Betwixt - Copyright 2012 Three Rings Design

#import "GDataXMLNode+BTExtensions.h"
#import "GDataXMLException.h"
#import "SPPoint+BTExtensions.h"
#import "SPRectangle+BTExtensions.h"

@implementation GDataXMLElement (BTExtensions)

- (SPPoint*)pointAttribute:(NSString*)name defaultVal:(SPPoint*)defaultVal required:(BOOL)required {
    NSString* attr = [self getAttr:name required:required];
    if (attr == nil) return defaultVal;

    SPPoint* p = [SPPoint pointFromString:attr];
    if (p != nil) return p;

    @throw [GDataXMLException withElement:self
       reason:@"Error reading attribute '%@': could not convert '%@' to SPPoint", name, attr];
}

- (SPPoint*)pointAttribute:(NSString*)name defaultVal:(SPPoint*)defaultVal {
    return [self pointAttribute:name defaultVal:defaultVal required:NO];
}

- (SPPoint*)pointAttribute:(NSString*)name {
    return [self pointAttribute:name defaultVal:nil required:YES];
}

- (SPRectangle*)rectangleAttribute:(NSString*)name defaultVal:(SPRectangle*)defaultVal required:(BOOL)required {
    NSString* attr = [self getAttr:name required:required];
    if (attr == nil) return defaultVal;

    SPRectangle* r = [SPRectangle rectangleFromString:attr];
    if (r != nil) return r;

    @throw [GDataXMLException withElement:self
       reason:@"Error reading attribute '%@': could not convert '%@' to SPRectangle", name, attr];
}

- (SPRectangle*)rectangleAttribute:(NSString*)name defaultVal:(SPRectangle*)defaultVal {
    return [self rectangleAttribute:name defaultVal:defaultVal required:NO];
}

- (SPRectangle*)rectangleAttribute:(NSString*)name {
    return [self rectangleAttribute:name defaultVal:nil required:YES];
}

@end
