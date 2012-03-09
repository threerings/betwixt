//
// Betwixt - Copyright 2012 Three Rings Design

#import "GDataXMLNode.h"

@class BTEnum;

@interface GDataXMLElement (OOOExtensions)

- (NSArray*)elements; // returns all child elements

- (BOOL)hasChild:(NSString*)name;
- (BOOL)hasAttribute:(NSString*)name;

- (NSString*)stringAttribute:(NSString*)name defaultVal:(NSString*)defaultVal;
- (NSString*)stringAttribute:(NSString*)name;
- (float)floatAttribute:(NSString*)name defaultVal:(float)defaultVal;
- (float)floatAttribute:(NSString*)name;
- (int)intAttribute:(NSString*)name defaultVal:(int)defaultVal;
- (int)intAttribute:(NSString*)name;
- (BOOL)boolAttribute:(NSString*)name defaultVal:(BOOL)defaultVal;
- (BOOL)boolAttribute:(NSString*)name;
- (id)enumAttribute:(NSString*)name type:(Class)type defaultVal:(BTEnum*)defaultVal;
- (id)enumAttribute:(NSString*)name type:(Class)type;

- (SPPoint*)pointAttribute:(NSString*)name defaultVal:(SPPoint*)defaultVal;
- (SPPoint*)pointAttribute:(NSString *)name;
- (SPRectangle*)rectangleAttribute:(NSString*)name defaultVal:(SPRectangle*)defaultVal;
- (SPRectangle*)rectangleAttribute:(NSString *)name;

- (GDataXMLElement*)requireChild:(NSString*)path;
- (GDataXMLElement*)getChild:(NSString*)path;

@end
