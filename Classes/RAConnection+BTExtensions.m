//
// Betwixt - Copyright 2012 Three Rings Design

#import "RAConnection+BTExtensions.h"

@implementation RAConnection (BTExtensions)

- (void)cancel {
    [self disconnect];
}

@end
