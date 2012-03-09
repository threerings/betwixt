//
// Betwixt - Copyright 2012 Three Rings Design

#import "GDataXMLNode+Extensions.h"
#import "GDataXMLException.h"
#import "NSString+Extensions.h"
#import "SPPoint+Extensions.h"
#import "SPRectangle+Extensions.h"

@implementation GDataXMLElement (OOOExtensions)

- (NSArray*)elements {
    NSMutableArray* elements = nil;
    for (GDataXMLNode* child in [self children]) {
        if ([child kind] == GDataXMLElementKind) {
            if (elements == nil) {
                elements = [NSMutableArray arrayWithObject:child];
            } else {
                [elements addObject:child];
            }
        }
    }
    return elements;
}

- (NSString*)getAttr:(NSString*)name required:(BOOL)required {
    GDataXMLNode* attr = [self attributeForName:name];
    if (attr == nil && required) {
        @throw [GDataXMLException withElement:self reason:@"Missing required attribute '%@'", name];
    }
    return (attr != nil ? [attr stringValue] : nil);
}

- (BOOL)hasChild:(NSString*)name {
    NSArray* children = [self elementsForName:name];
    return (children != nil && children.count > 0);
}

- (BOOL)hasAttribute:(NSString*)name; {
    return [self attributeForName:name] != nil;
}

- (NSString*)stringAttribute:(NSString*)name defaultVal:(NSString*)defaultVal {
    NSString* attr = [self getAttr:name required:NO];
    return (attr != nil ? attr : defaultVal);
}

- (NSString*)stringAttribute:(NSString*)name {
    return [self getAttr:name required:YES];
}

- (float)floatAttribute:(NSString*)name defaultVal:(float)defaultVal required:(BOOL)required {
    NSString* attr = [self getAttr:name required:required];
    if (attr == nil) return defaultVal;
    
    @try {
        return [attr requireFloatValue];
    } @catch (NSException* e) {
        @throw [GDataXMLException withElement:self 
                                       reason:@"Error reading attribute '%@': %@", name, e.reason];
    }
}

- (float)floatAttribute:(NSString*)name defaultVal:(float)defaultVal {
    return [self floatAttribute:name defaultVal:defaultVal required:NO];
}

- (float)floatAttribute:(NSString*)name {
    return [self floatAttribute:name defaultVal:0 required:YES];
}

- (int)intAttribute:(NSString*)name defaultVal:(int)defaultVal required:(BOOL)required {
    NSString* attr = [self getAttr:name required:required];
    if (attr == nil) return defaultVal;
    
    @try {
        return [attr requireIntValue];
    } @catch (NSException* e) {
        @throw [GDataXMLException withElement:self 
                                       reason:@"Error reading attribute '%@': %@", name, e.reason];
    }
}

- (int)intAttribute:(NSString*)name defaultVal:(int)defaultVal {
    return [self intAttribute:name defaultVal:defaultVal required:NO];
}

- (int)intAttribute:(NSString*)name {
    return [self intAttribute:name defaultVal:0 required:YES];
}

- (BOOL)boolAttribute:(NSString*)name defaultVal:(BOOL)defaultVal required:(BOOL)required {
    NSString* attr = [self getAttr:name required:required];
    if (attr == nil) return defaultVal;
    
    @try {
        return [attr requireBoolValue];
    } @catch (NSException* e) {
        @throw [GDataXMLException withElement:self 
                                       reason:@"Error reading attribute '%@': %@", name, e.reason];
    }
}

- (BOOL)boolAttribute:(NSString*)name defaultVal:(BOOL)defaultVal {
    return [self boolAttribute:name defaultVal:defaultVal required:NO];
}

- (BOOL)boolAttribute:(NSString*)name {
    return [self boolAttribute:name defaultVal:0 required:YES];
}

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

- (GDataXMLElement*)getChild:(NSString*)path {
    NSArray* els = [NSArray arrayWithObject:self];
    for (NSString* name in [path componentsSeparatedByString:@"/"]) {
        els = [[els objectAtIndex:0] elementsForName:name];
        if ([els count] > 1 || [els count] == 0) return nil;
    }
    return [els objectAtIndex:0];
}

- (GDataXMLElement*)requireChild:(NSString*)path {
    GDataXMLElement* current = self;
    for (NSString* name in [path componentsSeparatedByString:@"/"]) {
        NSArray* els = [current elementsForName:name];
        if ([els count] > 1) {
            @throw [GDataXMLException withElement:current
                reason:@"More than one child named '%@' in path '%@'", name, path];
        } else if ([els count] == 0) {
            @throw [GDataXMLException withElement:current
                reason:@"No child named '%@' in path '%@'", name, path];
        }
        current = [els objectAtIndex:0];
    }
    return current;
}

@end
