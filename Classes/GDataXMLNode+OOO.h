//
//  Betwixt - Copyright 2011 Three Rings Design

#import "GDataXMLNode.h"

@interface GDataXMLElement (OOOExtensions)

- (NSArray *)elements; // returns all child elements

- (BOOL)hasChild:(NSString *)name;
- (BOOL)hasAttribute:(NSString *)name;

- (NSString *)stringAttribute:(NSString *)name defaultVal:(NSString *)defaultVal;
- (NSString *)stringAttribute:(NSString *)name;
- (float)floatAttribute:(NSString *)name defaultVal:(float)defaultVal;
- (float)floatAttribute:(NSString *)name;
- (int)intAttribute:(NSString *)name defaultVal:(int)defaultVal;
- (int)intAttribute:(NSString *)name;
- (BOOL)boolAttribute:(NSString *)name defaultVal:(BOOL)defaultVal;
- (BOOL)boolAttribute:(NSString *)name;

@end
