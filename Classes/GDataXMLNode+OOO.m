//
//  Betwixt - Copyright 2011 Three Rings Design

#import "GDataXMLNode+OOO.h"
#import "GDataXMLException.h"

@implementation GDataXMLElement (OOOExtensions)

- (NSArray *)elements {
    NSMutableArray *elements = nil;
    for (GDataXMLNode *child in [self children]) {
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

- (NSString *)getAttr:(NSString *)name required:(BOOL)required {
    GDataXMLNode *attr = [self attributeForName:name];
    if (attr == nil && required) {
        @throw [GDataXMLException withElement:self reason:@"Missing required attribute '%@'", name];
    }
    return (attr != nil ? [attr stringValue] : nil);
}

- (BOOL)hasChild:(NSString *)name {
    NSArray *children = [self elementsForName:name];
    return (children != nil && children.count > 0);
}

- (BOOL)hasAttribute:(NSString *)name; {
    return [self attributeForName:name] != nil;
}

- (NSString *)stringAttribute:(NSString *)name defaultVal:(NSString *)defaultVal {
    NSString* attr = [self getAttr:name required:NO];
    return (attr != nil ? attr : defaultVal);
}

- (NSString *)stringAttribute:(NSString *)name {
    return [self getAttr:name required:YES];
}

- (float)floatAttribute:(NSString *)name defaultVal:(float)defaultVal required:(BOOL)required {
    NSString* attr = [self getAttr:name required:required];
    if (attr == nil) return defaultVal;
    NSScanner *scanner = [[NSScanner alloc] initWithString:attr];
    float retVal;
    if ([scanner scanFloat:&retVal] && [scanner isAtEnd]) return retVal;
    @throw [GDataXMLException withElement:self
        reason:@"Error reading attribute '%@': could not convert '%@' to int", name, attr];
}

- (float)floatAttribute:(NSString *)name defaultVal:(float)defaultVal {
    return [self floatAttribute:name defaultVal:defaultVal required:NO];
}

- (float)floatAttribute:(NSString *)name {
    return [self floatAttribute:name defaultVal:0 required:YES];
}

- (int)intAttribute:(NSString *)name defaultVal:(int)defaultVal required:(BOOL)required {
    NSString* attr = [self getAttr:name required:required];
    if (attr == nil) return defaultVal;

    NSScanner *scanner = [[NSScanner alloc] initWithString:attr];
    int retVal;
    if ([scanner scanInt:&retVal] && [scanner isAtEnd]) return retVal;
    @throw [GDataXMLException withElement:self
        reason:@"Error reading attribute '%@': could not convert '%@' to int", name, attr];
}

- (int)intAttribute:(NSString *)name defaultVal:(int)defaultVal {
    return [self intAttribute:name defaultVal:defaultVal required:NO];
}

- (int)intAttribute:(NSString *)name {
    return [self intAttribute:name defaultVal:0 required:YES];
}

- (BOOL)boolAttribute:(NSString *)name defaultVal:(BOOL)defaultVal required:(BOOL)required {
    NSString* attr = [self getAttr:name required:required];
    if (attr == nil) {
        return defaultVal;
    }

    attr = [attr lowercaseString];

    if ([attr isEqualToString:@"true"]) {
        return YES;
    } else if ([attr isEqualToString:@"false"]) {
        return NO;
    } else {
       @throw [GDataXMLException withElement:self reason:@"Error reading attribute '%@': could not convert '%@' to BOOL", name, attr];
    }
}

- (BOOL)boolAttribute:(NSString *)name defaultVal:(BOOL)defaultVal {
    return [self boolAttribute:name defaultVal:defaultVal required:NO];
}

- (BOOL)boolAttribute:(NSString *)name {
    return [self boolAttribute:name defaultVal:0 required:YES];
}

- (GDataXMLElement *) walkTo:(NSString *)path {
    GDataXMLElement *current = self;
    for (NSString* name in [path componentsSeparatedByString:@"/"]) {
        NSArray *els = [current elementsForName:name];
        if ([els count] > 1) {
            @throw [GDataXMLException withElement:self
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
