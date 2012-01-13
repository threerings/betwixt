//
//  gulp - Copyright 2012 Three Rings Design

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
    if (attr == nil) {
        return defaultVal;
    }
    
    const char *utf8 = [attr UTF8String];
    char *endptr;
    float val = strtof(utf8, &endptr);
    if (endptr != NULL) {
        @throw [GDataXMLException withElement:self reason:@"Error reading attribute '%@': could not convert '%@' to float", name, attr];
    }
    return val;
}

- (float)floatAttribute:(NSString *)name defaultVal:(float)defaultVal {
    return [self floatAttribute:name defaultVal:defaultVal required:NO];
}

- (float)floatAttribute:(NSString *)name {
    return [self floatAttribute:name defaultVal:0 required:YES];
}

- (int)intAttribute:(NSString *)name defaultVal:(int)defaultVal required:(BOOL)required {
    NSString* attr = [self getAttr:name required:required];
    if (attr == nil) {
        return defaultVal;
    }
    
    const char *utf8 = [attr UTF8String];
    char *endptr;
    long val = strtol(utf8, &endptr, 10);
    if (endptr != NULL) {
        @throw [GDataXMLException withElement:self reason:@"Error reading attribute '%@': could not convert '%@' to int", name, attr];
    }
    return (int) val;
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

@end
