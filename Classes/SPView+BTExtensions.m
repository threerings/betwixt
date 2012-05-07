//
// Betwixt - Copyright 2012 Three Rings Design

#import "SPView+BTExtensions.h"

@implementation SPView (BTExtensions)

- (BOOL)useNewSharedEAGLContext {
    EAGLContext *threadContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1 sharegroup:mContext.sharegroup];
    if (!threadContext) {
        NSLog(@"Unable to create shared EAGLContext!");
        return NO;
    }
    if (![EAGLContext setCurrentContext:threadContext]) {
        NSLog(@"Unable to set EAGLContext to new shared context!");
        return NO;
    }
    return YES;
}

@end
