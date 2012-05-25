//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPTextField+BTExtensions.h"

@implementation SPTextField (BTExtensions)

- (id)initWithFormat:(NSString *)text, ... {
    return [self initWithText:OOO_FORMAT_TO_STRING(text)];
}

@end
