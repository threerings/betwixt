//
//  Betwixt - Copyright 2011 Three Rings Design

#import <Foundation/Foundation.h>

@class GDataXMLElement;

@interface GDataXMLException : NSException

+ (GDataXMLException *)withReason:(NSString *)format, ...;
+ (GDataXMLException *)withElement:(GDataXMLElement *)badElement reason:(NSString *)format, ...;
- (id)initWithReason:(NSString *)reason;

@end
