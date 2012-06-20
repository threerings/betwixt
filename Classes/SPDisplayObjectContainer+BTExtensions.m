//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPDisplayObjectContainer+BTExtensions.h"

@implementation SPDisplayObjectContainer (BTExtensions)

- (SPDisplayObject*)childByFormatName:(NSString*)format, ... {
    return [self childByName:OOO_FORMAT_TO_STRING(format)];
}

@end
