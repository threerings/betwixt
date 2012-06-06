//
// Betwixt - Copyright 2012 Three Rings Design

#import "RAConnection.h"

/// Makes RAConnection compatible with the OOORegistration interface
@interface RAConnection (BTExtensions) <OOORegistration>
- (void)cancel; // calls through to disconnect
@end
