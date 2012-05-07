//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPView.h"

@interface SPView (BTExtensions)

/// Sets the current thread's EAGLContext to a new context that uses the main context's sharegroup. Call this when loading textures from a background thread. Returns YES if the new context was successfully set.
- (BOOL)useNewSharedEAGLContext;

@end
