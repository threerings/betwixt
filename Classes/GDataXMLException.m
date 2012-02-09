//
// Betwixt - Copyright 2012 Three Rings Design

#import "GDataXMLException.h"
#import "GDataXMLNode.h"

static NSString * const NAME = @"XMLException";

@implementation GDataXMLException

+ (GDataXMLException*)withReason:(NSString*)format, ... {
    va_list args;
    va_start(args, format);
    NSString* reason = [[NSString alloc]initWithFormat:format arguments:args];
    va_end(args);
    return [[GDataXMLException alloc] initWithReason:reason];
}

+ (GDataXMLException*)withElement:(GDataXMLElement*)badElement reason:(NSString*)format, ... {
    va_list args;
    va_start(args, format);
    NSMutableString* reason = [[NSMutableString alloc]initWithFormat:format arguments:args];
    va_end(args);
    
    if (badElement != nil) {
        [reason appendFormat:@"\n %@", [badElement description]];
    }
    
    return [[GDataXMLException alloc] initWithReason:reason];
}

- (id)initWithReason:(NSString*)reason
{
    if (!(self = [super initWithName:NAME reason:reason userInfo:nil])) {
        return nil;
    }
    return self;
}

@end
